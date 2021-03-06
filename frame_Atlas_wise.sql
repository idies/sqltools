/****** Object:  Index [i_Frame_field_camcol_run_zoom_re]    Script Date: 2/17/2017 1:22:26 PM ******/
CREATE NONCLUSTERED INDEX [i_Frame_field_camcol_run_zoom_re2] ON [dbo].[Frame]
(
	[field] ASC,
	[camcol] ASC,
	[run] ASC,
	[zoom] ASC,
	[rerun] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = ON, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = PAGE) ON FRAME
GO
/****** Object:  Index [i_Frame_htmID_zoom_cx_cy_cz_a_b_]    Script Date: 2/17/2017 1:22:26 PM ******/
CREATE NONCLUSTERED INDEX [i_Frame_htmID_zoom_cx_cy_cz_a_b_2] ON [dbo].[Frame]
(
	[htmID] ASC,
	[zoom] ASC,
	[cx] ASC,
	[cy] ASC,
	[cz] ASC,
	[a] ASC,
	[b] ASC,
	[c] ASC,
	[d] ASC,
	[e] ASC,
	[f] ASC,
	[node] ASC,
	[incl] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = ON, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = PAGE) ON FRAME
GO
/****** Object:  Index [i_WISE_allsky_blend_ext_flags]    Script Date: 2/17/2017 1:22:26 PM ******/
CREATE NONCLUSTERED INDEX [i_WISE_allsky_blend_ext_flags] ON [dbo].[WISE_allsky]
(
	[blend_ext_flags] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = ON, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = PAGE) ON WISE
GO
/****** Object:  Index [i_WISE_allsky_glat_glon]    Script Date: 2/17/2017 1:22:26 PM ******/
CREATE NONCLUSTERED INDEX [i_WISE_allsky_glat_glon] ON [dbo].[WISE_allsky]
(
	[glat] ASC,
	[glon] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = ON, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = PAGE) ON WISE
GO
/****** Object:  Index [i_WISE_allsky_h_m_2mass]    Script Date: 2/17/2017 1:22:26 PM ******/
CREATE NONCLUSTERED INDEX [i_WISE_allsky_h_m_2mass] ON [dbo].[WISE_allsky]
(
	[h_m_2mass] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = ON, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = PAGE) ON WISE
GO
/****** Object:  Index [i_WISE_allsky_j_m_2mass]    Script Date: 2/17/2017 1:22:26 PM ******/
CREATE NONCLUSTERED INDEX [i_WISE_allsky_j_m_2mass] ON [dbo].[WISE_allsky]
(
	[j_m_2mass] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = ON, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = PAGE) ON WISE
GO
/****** Object:  Index [i_WISE_allsky_k_m_2mass]    Script Date: 2/17/2017 1:22:26 PM ******/
CREATE NONCLUSTERED INDEX [i_WISE_allsky_k_m_2mass] ON [dbo].[WISE_allsky]
(
	[k_m_2mass] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = ON, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = PAGE) ON WISE
GO
/****** Object:  Index [i_WISE_allsky_n_2mass]    Script Date: 2/17/2017 1:22:26 PM ******/
CREATE NONCLUSTERED INDEX [i_WISE_allsky_n_2mass] ON [dbo].[WISE_allsky]
(
	[n_2mass] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = ON, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = PAGE) ON WISE
GO
/****** Object:  Index [i_WISE_allsky_ra_dec]    Script Date: 2/17/2017 1:22:26 PM ******/
CREATE NONCLUSTERED INDEX [i_WISE_allsky_ra_dec] ON [dbo].[WISE_allsky]
(
	[ra] ASC,
	[dec] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = ON, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = PAGE) ON WISE
GO
SET ARITHABORT ON
SET CONCAT_NULL_YIELDS_NULL ON
SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
SET NUMERIC_ROUNDABORT OFF

GO
/****** Object:  Index [i_WISE_allsky_rjce]    Script Date: 2/17/2017 1:22:26 PM ******/
CREATE NONCLUSTERED INDEX [i_WISE_allsky_rjce] ON [dbo].[WISE_allsky]
(
	[rjce] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = ON, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = PAGE) ON WISE
GO
/****** Object:  Index [i_WISE_allsky_tmass_key]    Script Date: 2/17/2017 1:22:26 PM ******/
CREATE NONCLUSTERED INDEX [i_WISE_allsky_tmass_key] ON [dbo].[WISE_allsky]
(
	[tmass_key] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = ON, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = PAGE) ON WISE
GO
/****** Object:  Index [i_WISE_allsky_w1cc_map]    Script Date: 2/17/2017 1:22:26 PM ******/
CREATE NONCLUSTERED INDEX [i_WISE_allsky_w1cc_map] ON [dbo].[WISE_allsky]
(
	[w1cc_map] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = ON, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = PAGE) ON WISE
GO
/****** Object:  Index [i_WISE_allsky_w1mpro]    Script Date: 2/17/2017 1:22:26 PM ******/
CREATE NONCLUSTERED INDEX [i_WISE_allsky_w1mpro] ON [dbo].[WISE_allsky]
(
	[w1mpro] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = ON, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = PAGE) ON WISE
GO
/****** Object:  Index [i_WISE_allsky_w1rsemi]    Script Date: 2/17/2017 1:22:26 PM ******/
CREATE NONCLUSTERED INDEX [i_WISE_allsky_w1rsemi] ON [dbo].[WISE_allsky]
(
	[w1rsemi] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = ON, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = PAGE) ON WISE
GO
/****** Object:  Index [i_WISE_allsky_w2cc_map]    Script Date: 2/17/2017 1:22:26 PM ******/
CREATE NONCLUSTERED INDEX [i_WISE_allsky_w2cc_map] ON [dbo].[WISE_allsky]
(
	[w2cc_map] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = ON, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = PAGE) ON WISE
GO
/****** Object:  Index [i_WISE_allsky_w2mpro]    Script Date: 2/17/2017 1:22:26 PM ******/
CREATE NONCLUSTERED INDEX [i_WISE_allsky_w2mpro] ON [dbo].[WISE_allsky]
(
	[w2mpro] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = ON, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = PAGE) ON WISE
GO
/****** Object:  Index [i_WISE_allsky_w3cc_map]    Script Date: 2/17/2017 1:22:26 PM ******/
CREATE NONCLUSTERED INDEX [i_WISE_allsky_w3cc_map] ON [dbo].[WISE_allsky]
(
	[w3cc_map] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = ON, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = PAGE) ON WISE
GO
/****** Object:  Index [i_WISE_allsky_w3mpro]    Script Date: 2/17/2017 1:22:26 PM ******/
CREATE NONCLUSTERED INDEX [i_WISE_allsky_w3mpro] ON [dbo].[WISE_allsky]
(
	[w3mpro] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = ON, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = PAGE) ON WISE
GO
/****** Object:  Index [i_WISE_allsky_w4cc_map]    Script Date: 2/17/2017 1:22:26 PM ******/
CREATE NONCLUSTERED INDEX [i_WISE_allsky_w4cc_map] ON [dbo].[WISE_allsky]
(
	[w4cc_map] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = ON, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = PAGE) ON WISE
GO
/****** Object:  Index [i_WISE_allsky_w4mpro]    Script Date: 2/17/2017 1:22:26 PM ******/
CREATE NONCLUSTERED INDEX [i_WISE_allsky_w4mpro] ON [dbo].[WISE_allsky]
(
	[w4mpro] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = ON, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = PAGE) ON WISE
GO
/****** Object:  Index [i_wiseForcedTarget_ra_dec_has_wi]    Script Date: 2/17/2017 1:22:26 PM ******/
CREATE NONCLUSTERED INDEX [i_wiseForcedTarget_ra_dec_has_wi] ON [dbo].[wiseForcedTarget]
(
	[ra] ASC,
	[dec] ASC,
	[has_wise_phot] ASC,
	[treated_as_pointsource] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = ON, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = PAGE) ON WISE
GO
ALTER TABLE [dbo].[Frame] ADD  DEFAULT ((0)) FOR [mu]
GO
ALTER TABLE [dbo].[Frame] ADD  DEFAULT ((0)) FOR [nu]
GO
ALTER TABLE [dbo].[Frame] ADD  DEFAULT ((0)) FOR [ra]
GO
ALTER TABLE [dbo].[Frame] ADD  DEFAULT ((0)) FOR [dec]
GO
ALTER TABLE [dbo].[Frame] ADD  DEFAULT ((0)) FOR [cx]
GO
ALTER TABLE [dbo].[Frame] ADD  DEFAULT ((0)) FOR [cy]
GO
ALTER TABLE [dbo].[Frame] ADD  DEFAULT ((0)) FOR [cz]
GO
ALTER TABLE [dbo].[Frame] ADD  DEFAULT ((0)) FOR [htmID]
GO
ALTER TABLE [dbo].[Frame] ADD  DEFAULT (0x1111) FOR [img]
GO
ALTER TABLE [dbo].[WISE_allsky] ADD  DEFAULT ((0)) FOR [glat]
GO
ALTER TABLE [dbo].[WISE_allsky] ADD  DEFAULT ((0)) FOR [glon]
GO
