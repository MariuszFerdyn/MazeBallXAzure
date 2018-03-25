USE [MazeBall]
GO
/****** Object:  Table [dbo].[wyniki]    Script Date: 3/25/2018 8:13:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[wyniki](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[Nick] [nvarchar](50) NOT NULL,
	[Wynik] [numeric](18, 0) NOT NULL,
	[Czas] [numeric](18, 0) NOT NULL,
	[System] [nvarchar](50) NOT NULL,
	[Mail] [nvarchar](50) NULL,
	[Data] [datetime] NULL
) ON [PRIMARY]
GO
