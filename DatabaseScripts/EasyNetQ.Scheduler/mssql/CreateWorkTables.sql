USE [EasyNetQ.Scheduler]
GO

/****** Object:  Table [dbo].[WorkItems]    Script Date: 2019-03-21 11:21:36 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[WorkItems](
	[WorkItemID] [int] IDENTITY(1,1) NOT NULL,
	[BindingKey] [nvarchar](1000) NOT NULL,
	[CancellationKey] [nvarchar](255) NULL,
	[InnerMessage] nvarchar(max) NOT NULL,
	[TextData] [nvarchar](max) NULL,
	[InstanceName] [nvarchar](100) NOT NULL,
	[Exchange] [nvarchar](256) NULL,
	[ExchangeType] [nvarchar](16) NULL,
	[RoutingKey] [nvarchar](256) NULL,
	[MessageProperties] [nvarchar](max) NULL,
 CONSTRAINT [PK_WorkItems] PRIMARY KEY CLUSTERED 
(
	[WorkItemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[WorkItems] ADD  DEFAULT ('') FOR [InstanceName]
GO


