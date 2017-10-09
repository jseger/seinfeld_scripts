USE [master]
GO
/****** Object:  Database [SeinfeldScripts]    Script Date: 10/9/2017 11:42:06 AM ******/
CREATE DATABASE [SeinfeldScripts]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'SeinfeldScripts', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.SQLEXPRESS\MSSQL\DATA\SeinfeldScripts.mdf' , SIZE = 168000KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'SeinfeldScripts_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.SQLEXPRESS\MSSQL\DATA\SeinfeldScripts_log.ldf' , SIZE = 636928KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [SeinfeldScripts] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [SeinfeldScripts].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [SeinfeldScripts] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [SeinfeldScripts] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [SeinfeldScripts] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [SeinfeldScripts] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [SeinfeldScripts] SET ARITHABORT OFF 
GO
ALTER DATABASE [SeinfeldScripts] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [SeinfeldScripts] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [SeinfeldScripts] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [SeinfeldScripts] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [SeinfeldScripts] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [SeinfeldScripts] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [SeinfeldScripts] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [SeinfeldScripts] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [SeinfeldScripts] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [SeinfeldScripts] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [SeinfeldScripts] SET  ENABLE_BROKER 
GO
ALTER DATABASE [SeinfeldScripts] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [SeinfeldScripts] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [SeinfeldScripts] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [SeinfeldScripts] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [SeinfeldScripts] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [SeinfeldScripts] SET READ_COMMITTED_SNAPSHOT ON 
GO
ALTER DATABASE [SeinfeldScripts] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [SeinfeldScripts] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [SeinfeldScripts] SET  MULTI_USER 
GO
ALTER DATABASE [SeinfeldScripts] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [SeinfeldScripts] SET DB_CHAINING OFF 
GO
ALTER DATABASE [SeinfeldScripts] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [SeinfeldScripts] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
USE [SeinfeldScripts]
GO
/****** Object:  FullTextCatalog [ScriptLinesFullTextCatalog]    Script Date: 10/9/2017 11:42:06 AM ******/
CREATE FULLTEXT CATALOG [ScriptLinesFullTextCatalog]
GO
/****** Object:  UserDefinedFunction [dbo].[edit_distance]    Script Date: 10/9/2017 11:42:06 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[edit_distance](@s1 nvarchar(3999), @s2 nvarchar(3999))
RETURNS int
AS
BEGIN
 DECLARE @s1_len int, @s2_len int
 DECLARE @i int, @j int, @s1_char nchar, @c int, @c_temp int
 DECLARE @cv0 varbinary(8000), @cv1 varbinary(8000)

 SELECT
  @s1_len = LEN(@s1),
  @s2_len = LEN(@s2),
  @cv1 = 0x0000,
  @j = 1, @i = 1, @c = 0

 WHILE @j <= @s2_len
  SELECT @cv1 = @cv1 + CAST(@j AS binary(2)), @j = @j + 1

 WHILE @i <= @s1_len
 BEGIN
  SELECT
   @s1_char = SUBSTRING(@s1, @i, 1),
   @c = @i,
   @cv0 = CAST(@i AS binary(2)),
   @j = 1

  WHILE @j <= @s2_len
  BEGIN
   SET @c = @c + 1
   SET @c_temp = CAST(SUBSTRING(@cv1, @j+@j-1, 2) AS int) +
    CASE WHEN @s1_char = SUBSTRING(@s2, @j, 1) THEN 0 ELSE 1 END
   IF @c > @c_temp SET @c = @c_temp
   SET @c_temp = CAST(SUBSTRING(@cv1, @j+@j+1, 2) AS int)+1
   IF @c > @c_temp SET @c = @c_temp
   SELECT @cv0 = @cv0 + CAST(@c AS binary(2)), @j = @j + 1
 END

 SELECT @cv1 = @cv0, @i = @i + 1
 END

 RETURN @c
END
GO
/****** Object:  Table [dbo].[__MigrationHistory]    Script Date: 10/9/2017 11:42:06 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[__MigrationHistory](
	[MigrationId] [nvarchar](150) NOT NULL,
	[ContextKey] [nvarchar](300) NOT NULL,
	[Model] [varbinary](max) NOT NULL,
	[ProductVersion] [nvarchar](32) NOT NULL,
 CONSTRAINT [PK_dbo.__MigrationHistory] PRIMARY KEY CLUSTERED 
(
	[MigrationId] ASC,
	[ContextKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ScriptLines]    Script Date: 10/9/2017 11:42:06 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ScriptLines](
	[ScriptLineId] [uniqueidentifier] NOT NULL DEFAULT (newsequentialid()),
	[ScriptId] [uniqueidentifier] NOT NULL,
	[Actor] [nvarchar](500) NULL,
	[Line] [nvarchar](4000) NULL,
 CONSTRAINT [PK_dbo.ScriptLines] PRIMARY KEY CLUSTERED 
(
	[ScriptLineId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Scripts]    Script Date: 10/9/2017 11:42:06 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Scripts](
	[ScriptId] [uniqueidentifier] NOT NULL DEFAULT (newsequentialid()),
	[Title] [nvarchar](max) NULL,
	[Season] [nvarchar](max) NULL,
	[Episode] [nvarchar](max) NULL,
	[Date] [datetime] NOT NULL,
 CONSTRAINT [PK_dbo.Scripts] PRIMARY KEY CLUSTERED 
(
	[ScriptId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Words]    Script Date: 10/9/2017 11:42:06 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Words](
	[Key] [nvarchar](128) NOT NULL,
	[Count] [int] NOT NULL,
 CONSTRAINT [PK_dbo.Words] PRIMARY KEY CLUSTERED 
(
	[Key] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[WordScriptLines]    Script Date: 10/9/2017 11:42:06 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WordScriptLines](
	[Word_Key] [nvarchar](128) NOT NULL,
	[ScriptLine_ScriptLineId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_dbo.WordScriptLines] PRIMARY KEY CLUSTERED 
(
	[Word_Key] ASC,
	[ScriptLine_ScriptLineId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO