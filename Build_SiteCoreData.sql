USE [cmqa]
GO

/****** Object:  Table [dbo].[SiteCoreData]    Script Date: 6/12/2017 8:56:20 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SiteCoreData](
	[ObjectID] [int] NOT NULL,
	[ObjectTypeID] [int] NULL,
	[ObjectType_Description] [nvarchar](max) NULL,
	[t_ObjectID] [int] NOT NULL,
	[t_ObjectTypeID] [int] NULL,
	[t_ObjectType_Description] [nvarchar](max) NULL,
	[ParentObjectID] [int] NULL,
	[t_ParentObjectID] [int] NULL,
	[Name] [nvarchar](max) NULL,
	[SimpleName] [nvarchar](max) NULL,
	[Path] [nvarchar](max) NULL,
	[UpdateDate] [datetime] NOT NULL,
	[BlobSize] [bigint] NULL,
	[BlobData] [varbinary](max) NULL,
	[Extension] [nvarchar](50) NULL,
	[Title] [nvarchar](max) NULL,
	[ShortDescription] [nvarchar](max) NULL,
	[ItemDate] [nvarchar](max) NULL,
	[BodyText] [nvarchar](max) NULL,
	[AuthorID] [int] NULL,
	[AuthorName] [nvarchar](max) NULL,
	[Searchable] [nvarchar](50) NULL,
	[ShowNavigation] [nvarchar](50) NULL,
	[Keyword] [nvarchar](max) NULL,
	[Group] [nvarchar](max) NULL,
	[ID] [int] IDENTITY(1,1) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ObjectID] ASC,
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO


