--customer db.
:SETVAR DatabasePrefix SitecoreCustomerPrefix
-- clear just deployed db prefix.
:SETVAR NewDatabasePrefix Test4 

:SETVAR ShardMapManagerDatabaseNameSuffix _Xdb.Collection.ShardMapManager
:SETVAR CustomerShard0DatabaseNameSuffix _Xdb.Collection.Shard0 --when azure is used names may be different
:SETVAR CustomerShard1DatabaseNameSuffix _Xdb.Collection.Shard1 --when azure is used names may be different
:SETVAR Shard0DatabaseNameSuffix _Xdb.Collection.Shard0 
:SETVAR Shard1DatabaseNameSuffix _Xdb.Collection.Shard1 

--Remove and add needed data for shard0.
USE [$(DatabasePrefix)$(CustomerShard0DatabaseNameSuffix)] 
GO

Delete from [__ShardManagement].ShardMappingsLocal
Delete from [__ShardManagement].ShardsLocal
Delete from [__ShardManagement].ShardMapsLocal
Delete from [__ShardManagement].ShardMapManagerLocal

INSERT INTO [__ShardManagement].ShardMapsLocal
  SELECT *
  FROM [$(NewDatabasePrefix)$(Shard0DatabaseNameSuffix)].[__ShardManagement].ShardMapsLocal

INSERT INTO [__ShardManagement].ShardsLocal
  SELECT *
  FROM [$(NewDatabasePrefix)$(Shard0DatabaseNameSuffix)].[__ShardManagement].ShardsLocal

INSERT INTO [__ShardManagement].ShardMapManagerLocal
  SELECT *
  FROM [$(NewDatabasePrefix)$(Shard0DatabaseNameSuffix)].[__ShardManagement].ShardMapManagerLocal

INSERT INTO [__ShardManagement].ShardMappingsLocal
  SELECT *
  FROM [$(NewDatabasePrefix)$(Shard0DatabaseNameSuffix)].[__ShardManagement].ShardMappingsLocal

UPDATE [__ShardManagement].[ShardsLocal]
   SET 
      [DatabaseName] = '$(DatabasePrefix)$(CustomerShard0DatabaseNameSuffix)'

--Remove and add needed data for shard1.
USE [$(DatabasePrefix)$(CustomerShard1DatabaseNameSuffix)] 
GO

Delete from [__ShardManagement].ShardMappingsLocal
Delete from [__ShardManagement].ShardsLocal
Delete from [__ShardManagement].ShardMapsLocal
Delete from [__ShardManagement].ShardMapManagerLocal

INSERT INTO [__ShardManagement].ShardMapsLocal
  SELECT *
  FROM [$(NewDatabasePrefix)$(Shard1DatabaseNameSuffix)].[__ShardManagement].ShardMapsLocal

INSERT INTO [__ShardManagement].ShardsLocal
  SELECT *
  FROM [$(NewDatabasePrefix)$(Shard1DatabaseNameSuffix)].[__ShardManagement].ShardsLocal

INSERT INTO [__ShardManagement].ShardMapManagerLocal
  SELECT *
  FROM [$(NewDatabasePrefix)$(Shard1DatabaseNameSuffix)].[__ShardManagement].ShardMapManagerLocal

INSERT INTO [__ShardManagement].ShardMappingsLocal
  SELECT *
  FROM [$(NewDatabasePrefix)$(Shard1DatabaseNameSuffix)].[__ShardManagement].ShardMappingsLocal

UPDATE [__ShardManagement].[ShardsLocal]
   SET 
      [DatabaseName] = '$(DatabasePrefix)$(CustomerShard1DatabaseNameSuffix)'

--Remove and add needed data for shardmap manager
USE [$(NewDatabasePrefix)$(ShardMapManagerDatabaseNameSuffix)] 
GO

UPDATE [__ShardManagement].[ShardsGlobal]
   SET 
      [DatabaseName] = '$(DatabasePrefix)$(CustomerShard1DatabaseNameSuffix)'
   WHERE
      [DatabaseName] = '$(NewDatabasePrefix)$(Shard1DatabaseNameSuffix)'

UPDATE [__ShardManagement].[ShardsGlobal]
   SET 
      [DatabaseName] = '$(DatabasePrefix)$(CustomerShard0DatabaseNameSuffix)'
   WHERE
      [DatabaseName] = '$(NewDatabasePrefix)$(Shard0DatabaseNameSuffix)'
