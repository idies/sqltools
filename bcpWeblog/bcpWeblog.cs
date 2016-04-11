using System;
using System.IO;
using System.Diagnostics;
using System.Text.RegularExpressions;

namespace bcpWeblog
{
	/// <summary>
	/// Summary description for bcpWeblog.
	/// </summary>
	class bcpWeblog
	{
		/// <summary>
		/// The main entry point for the application.
		/// </summary>
		static int totalLines = 0;
		static int totalFiles = 0;
		static double totalBytes = 0;
		static bool doBcp = true;
		static string dataTree;
		static string minAge;

		[STAThread]
		static void Main(string[] args)
		{
			//
			// TODO: Add code to start application here
			//
			if( args.Length < 2 ) 
				Usage();
			dataTree = args[0];
			if( !Directory.Exists(dataTree) ) 
				Usage();
			minAge = args[1];
			if( args.Length > 2 && args[2] == "-SuppressBcp" )
				doBcp = false;
			ScanFolder( dataTree, "^ex.*\\.log$");
		}

		//****************************************************************************************
		//   Supporting routines.
		//****************************************************************************************
		//  ScanFolder() matches pattern to all names in folder and invokes bcp on matching files
		//****************************************************************************************
		public static void ScanFolder( string dataTree, string wildSpec )
		{
			DirectoryInfo di = new DirectoryInfo(dataTree);
			foreach( FileInfo fi in di.GetFiles() )
			{
				if( Regex.IsMatch(fi.Name,wildSpec,RegexOptions.Compiled&RegexOptions.Multiline&RegexOptions.IgnoreCase ) )
				{
  //                  Console.WriteLine("Processing file {0} ...", fi.Name);
                    if (doBcp)
						LaunchBcp( fi );
					else
						Console.WriteLine( "Skipping LaunchBcp for {0} ...", fi.Name );
				}
			}
			foreach( DirectoryInfo fo in di.GetDirectories() )
			{
				ScanFolder( fo.FullName, wildSpec );
			}
		}

		public static void LaunchBcp( FileInfo fi )
		{
			int lineCount = MakeLoadFile( fi );				// count the lines
            Console.WriteLine("LaunchBcp {0}, count={1} ...", fi.Name, lineCount);
            if( doBcp && (lineCount > 0) ) 
			{
				// Console.WriteLine("{0}: linecount = {1}", fi.FullName, lineCount );
				Process proc = null;
				ProcessStartInfo procInfo = new ProcessStartInfo("bcp.exe");
				procInfo.UseShellExecute = false;
				procInfo.CreateNoWindow = true;
				procInfo.Arguments="weblog.dbo.weblogTemp in c:\\temp\\bcp.tmp -S localhost -T -c -ec:\\Temp\\rejectedBcpRecords.txt";
				proc = Process.Start(procInfo);
				proc.WaitForExit();
				int bcpReturnCode = proc.ExitCode;
				if( bcpReturnCode != 0 )
					Console.WriteLine( "bcp command failed, return code = {0}", bcpReturnCode );
				totalFiles += 1;		
				totalLines += lineCount;
				totalBytes += fi.Length;
			}
		}

		public static int MakeLoadFile( FileInfo fi )
		{
			// if the file does not qualify (too old, or too short) return
			int count = 0;
			// StreamReader candidateFile = fi.OpenText();
			FileStream inFile = new FileStream(fi.FullName, FileMode.Open, FileAccess.Read, FileShare.ReadWrite);
			StreamReader candidateFile = new StreamReader(inFile);
			if( candidateFile.ReadLine() == null ) return( 0 );
			if( candidateFile.ReadLine() == null ) return( 0 );
            if (candidateFile.ReadLine() == null) return (0);
            if (candidateFile.ReadLine() == null) return (0);
            string line = "";
			if( (line = candidateFile.ReadLine()) == null ) return( 0 );
			if( line.IndexOf("20") != 0 ) 
			{
				Console.WriteLine("file: {0} not a good log file, skipping it.", fi.FullName );
				candidateFile.Close();
				return( 0 );
			}
//			string date = line.Substring( 0, 10 );
            string dateTime = line.Substring(0, 19);
            DateTime dt = Convert.ToDateTime(dateTime);
            dt= dt.AddDays(1);
            string date = dt.ToString("yyyy-MM-dd");
//            int dd = Int32.Parse(ddstr);
//            dd += 1;
//            Console.WriteLine("Line: {0}", line);
			int result = String.CompareOrdinal( date, minAge );
//            Console.WriteLine("Date: {0}, MinAge: {1}, result = {2}, datetime = {3}", date, minAge, result, dateTime);
            if (result < 0) 
			{	// Min Age specified in command line
				Console.WriteLine( "file: {0} too old, skipping it.", fi.FullName );
				candidateFile.Close();
				return( 0 );
			}
//			Console.WriteLine( "Processing file: {0}", fi.FullName );
			candidateFile.Close();
			string format = "old";

			// make a local copy of the file -- avoids interlock with web server.
//			Console.WriteLine( "about to copy {0}", fi.FullName );
			fi.CopyTo( "c:\\temp\\weblog.txt", true );
			FileInfo ft = new FileInfo( "c:\\temp\\weblog.txt" );
			StreamReader inStream  = ft.OpenText();
			FileInfo fo = new FileInfo("C:\\temp\\bcp.tmp");
            StreamWriter outStream = new StreamWriter(fo.Create(), System.Text.Encoding.UTF8);
			while( (line = inStream.ReadLine()) != null )
			{	 
//				Console.WriteLine("input: {0}", line);
				if( (line.IndexOf("#") != 0) && (line.Length > 20) && (line.Length < 8000))
				{
					line = remap(line,format);  
					// convert to Fermi Normal form
					if (line.IndexOf("\t") != 0) 
					{  	
						// have some delimiters (not null).
						string outStr = Regex.Replace( date,"-","\t" ) + "\t" + count;
						outStr += "\t" + Regex.Replace( line, " ", "\t" );
						outStream.WriteLine( outStr );
						// Console.WriteLine( "output: {0}", line );
						count +=  1;
					}
				} 
				else
				{
					if( line.IndexOf("#Fields") == 0 ) 
					{
						if( line.IndexOf("sc-bytes") > 0 )
							format = "new";
						else
							format = "old";
					}
				}
				if( line.Length >= 8000) Console.WriteLine( "Line too long (more than 8K chars): {0}", line );
			}
			inStream.Close();  
			outStream.Close();
			ft.Delete();	// do not need the copy anymore
			return( count );
		}

		public static string remap( string line, string format )
		{
			string ans, next, method, url, browser, clientIp="", errCode="", referer="-", bytesOut="0", bytesIn="0", elapsed="0";
			int fieldCount, nextField=0;

			if( format == "new" )
				fieldCount = 16;
			else
				fieldCount = 11;
			Regex re = new Regex( "[^ ]+",RegexOptions.Compiled&RegexOptions.Singleline&RegexOptions.IgnoreCase );
			Regex code = new Regex( "^[0-9]{3}$",RegexOptions.Compiled&RegexOptions.Singleline&RegexOptions.IgnoreCase );
			MatchCollection MatchList = re.Matches(line);
			if( MatchList.Count < fieldCount ) return "";
			if ((next = MatchList[nextField++].Value) == null) return "" ;	// date (ignore)
			if ((next = MatchList[nextField++].Value) == null) return "" ;
			ans = next;   											// hh
			if( format == "new" ) 
			{
				if ((next = MatchList[nextField++].Value) == null) return "" ;	// service name (ignore)
			}
			if ((next = MatchList[nextField++].Value) == null) return "" ;	// server ipaddr
			if ((next = MatchList[nextField++].Value) == null) return "" ;	// method: get, post,...
			method = next;
			if ((next = MatchList[nextField++].Value) == null) return "" ;	// url
			url = next;
			if ((next = MatchList[nextField++].Value) == null) return "" ;	// param string or error code
			if (!code.IsMatch(next))
			{
				url = url + "?" + next;
				if( url.Length > 256 )
					url = url.Substring( 0, 255 );
			} 	
			if ((next = MatchList[nextField++].Value) == null) return "" ;	// server port
			if ((next = MatchList[nextField++].Value) == null) return "" ;	// user name
			if ((next = MatchList[nextField++].Value) == null) return "" ;	// client IP but not really
			if ((next = MatchList[nextField++].Value) == null) return "" ;	// browser
			browser = next;  
			if( format == "new" ) 
			{
				if ((next = MatchList[nextField++].Value) == null) return "" ;	// referer
				referer = next;
			}
			if ((next = MatchList[nextField++].Value) == null) return "" ;	// error code
            errCode = next;
            if( format == "new" ) 
			{
				if ((next = MatchList[nextField++].Value) == null) return "" ;	// sc-bytes
				bytesOut = next;  
				if ((next = MatchList[nextField++].Value) == null) return "" ;	// cs-bytes
				bytesIn = next;  
				if ((next = MatchList[nextField++].Value) == null) return "" ;	// time-taken
				elapsed = next;
                if ((next = MatchList[nextField++].Value) == null) return "";	// xForwardedFor = real client-IP
                clientIp = next;
            }
            ans = ans + "\t" + clientIp;
            ans = ans + "\t" + method;					  
            ans = ans + "\t" + url;
            ans = ans + "\t" + errCode;
            ans = ans + "\t" + browser;
            ans = ans + "\t" + referer;  
			ans = ans + "\t" + bytesOut;  
			ans = ans + "\t" + bytesOut;  
			ans = ans + "\t" + elapsed;  
			return ans;
		}

		public static void Usage()
		{
			Console.WriteLine("Loads IIS log files into local SQL Server WebLog.dbo.WeblogTemp table."); 
			Console.WriteLine("Usage: bcpWeblog <directory>  MinAge [-SupressBcp]");
			Console.WriteLine("bcpWeblog c:\\windows\\system32\\logfiles 2002-02-15 -SupressBcp " );
			Environment.Exit(1);
		}
	}
}
