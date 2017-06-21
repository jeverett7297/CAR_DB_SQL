USE [cmqa]
GO

/****** Object:  Table [dbo].[SiteCoreData]    Script Date: 6/21/2017 10:04:17 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SiteCoreData](
	[ObjectID] [int] NULL,
	[ObjectTypeID] [int] NULL,
	[ObjectType_Description] [nvarchar](max) NULL,
	[t_ObjectID] [int] NULL,
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
	[ContentRef] [int] NULL,
	[Status] [varchar](100) NULL,
	[t_Status] [varchar](100) NULL,
	[StatusID] [int] NULL,
	[t_StatusID] [int] NULL,
	[StartDate] [varchar](100) NULL,
	[EndDate] [varchar](100) NULL,
	[ExpiryDate] [varchar](100) NULL,
	[EventType] [varchar](500) NULL,
	[InPerson] [varchar](200) NULL,
	[Location] [varchar](200) NULL,
	[Topic] [varchar](200) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO


