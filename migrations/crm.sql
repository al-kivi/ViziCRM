DROP TABLE IF EXISTS "accounts";
CREATE TABLE "accounts" ("id" INTEGER PRIMARY KEY  NOT NULL ,"user_id" INTEGER,"assigned_id" INTEGER,"name" CHAR(64),"website" CHAR(64),"phone" CHAR(32),"email" CHAR(64),"rating" char(5),"category" CHAR(32),"public" BOOL DEFAULT (1) ,"created_at" DATETIME,"updated_at" DATETIME,"deleted_at" DATETIME);
INSERT INTO "accounts" VALUES(1,1,1,'Giant Corporation','www.giant.com','416-967-1111','sales@giant.com','*','Customer','t','2012-09-01','2012-09-29 22:20:00.858214-0400',NULL);
INSERT INTO "accounts" VALUES(2,1,'','Medium Limited','www.medium.com','416-967-1111','test@medium.com','**','Competitor','t','2012-09-01','2012-09-08 23:20:51.499276-0400',NULL);
INSERT INTO "accounts" VALUES(3,1,NULL,'Tiny Co','www.tiny.com','416-967-1111','admin@tiny.com','***','Customer','t','2012-09-08 11:00:33.093496-0400','2012-09-08 11:01:07.034771-0400',NULL);
INSERT INTO "accounts" VALUES(4,1,NULL,'IBM Global','www.ibm.com','416-967-1111','mrbig@ibm.com','***','Customer','t','2012-09-08 22:24:14.203371-0400','2012-10-07 15:05:34.100866-0400',NULL);
DROP TABLE IF EXISTS "actions";
CREATE TABLE "actions" ("id" INTEGER PRIMARY KEY  NOT NULL ,"user_id" INTEGER,"actiontype" CHAR(10),"modeltype" CHAR(10),"itemname" CHAR(64),"created_at" DATETIME, "item_id" INTEGER);
INSERT INTO "actions" VALUES(1,1,'updated','campaign','New Product EBlast','2012-09-30 21:33:35.305387-0400',1);
INSERT INTO "actions" VALUES(2,1,'updated','task','Need to setup another database record','2012-10-07 22:28:02.760881-0400',1);
INSERT INTO "actions" VALUES(3,1,'updated','campaign','New Product EBlast','2012-10-07 22:28:12.654296-0400',1);
INSERT INTO "actions" VALUES(4,1,'updated','lead','Harper','2012-10-07 22:41:24.437808-0400',1);
INSERT INTO "actions" VALUES(5,1,'updated','account','IBM Global','2012-10-07 22:41:35.851909-0400',4);
INSERT INTO "actions" VALUES(6,1,'updated','contact','Smith','2012-10-07 22:41:47.452764-0400',1);
INSERT INTO "actions" VALUES(7,1,'updated','opport','Big Deal','2012-10-07 22:41:58.469471-0400',1);
DROP TABLE IF EXISTS "campaigns";
CREATE TABLE "campaigns" ("id" INTEGER PRIMARY KEY  NOT NULL ,"user_id" INTEGER,"name" CHAR(64),"status" CHAR(64),"starts_on" DATETIME,"ends_on" DATETIME,"public" BOOL DEFAULT (1) ,"budget" REAL(12,2) DEFAULT (99) ,"target_leads" INTEGER DEFAULT (0) ,"target_revenue" real(12,2) DEFAULT (0) ,"revenue" real(12,2) DEFAULT (0) ,"objectives" text,"deleted_at" DATETIME,"created_at" DATETIME,"updated_at" DATETIME);
INSERT INTO "campaigns" VALUES(1,1,'New Product EBlast','Started','2012-09-12 00:00:00.000000-0400','2012-09-14 00:00:00.000000-0400','t',99,10,123,99,NULL,NULL,'2012-09-10 23:11:37.468134-0400','2012-10-07 14:41:06.165407-0400');
INSERT INTO "campaigns" VALUES(2,1,'Northeast Marketing Program','Planned','2012-09-14 00:00:00.000000-0400','2012-09-28 00:00:00.000000-0400','t',99,5,0,99,NULL,NULL,'2012-09-17 20:12:53.119406-0400','2012-10-07 14:41:35.953442-0400');
DROP TABLE IF EXISTS "comments";
CREATE TABLE `comments` (`id` integer PRIMARY KEY AUTOINCREMENT, `username` varchar(255) NULL, `comment` text NOT NULL, `created_at` timestamp, `post_id` integer REFERENCES `posts`(`id`) ON DELETE CASCADE ON UPDATE CASCADE, `user_id` integer REFERENCES `users`(`id`) ON DELETE CASCADE ON UPDATE CASCADE);
INSERT INTO "comments" VALUES(2,NULL,'This post is all Greek to me.','2012-07-07 17:16:57.601319-0400',7,1);
DROP TABLE IF EXISTS "contacts";
CREATE TABLE "contacts" ("id" INTEGER PRIMARY KEY  NOT NULL ,"user_id" INTEGER,"lead_id" INTEGER,"assigned_id" INTEGER,"reportsto_id" INTEGER DEFAULT (99) ,"first_name" char(64),"last_name" char(64),"email" char(64),"phone" char(64),"public" BOOL DEFAULT (1) ,"title" CHAR(64),"department" char(64),"source" char(32),"do_not_call" BOOL,"deleted_at" DATETIME,"created_at" DATETIME,"updated_at" DATETIME,"campaign_id" INTEGER,"full_name" char(64),"account_id" INTEGER);
INSERT INTO "contacts" VALUES(1,1,NULL,3,NULL,'John','Smith','j.smith@gmail.com','222-2121','t',NULL,NULL,'Cold Call',NULL,NULL,'2012-09-14 21:25:29.562235-0400','2012-10-07 15:00:47.774303-0400',2,'Smith, John',4);
INSERT INTO "contacts" VALUES(2,1,1,1,NULL,'Steven','Harper','steven@gmail.com','','t',NULL,NULL,NULL,NULL,NULL,'2012-09-27 23:12:56.932490-0400',NULL,2,'Harper, Steven',1);
INSERT INTO "contacts" VALUES(3,1,1,1,NULL,'Steven','Harper','steven@gmail.com','',1,NULL,NULL,NULL,NULL,NULL,'2012-10-06 17:41:57.021262-0400',NULL,2,'Harper, Steven',1);
DROP TABLE IF EXISTS "leads";
CREATE TABLE leads (
    "id" INTEGER PRIMARY KEY NOT NULL,
    "user_id" INTEGER,
    "campaign_id" INTEGER,
    "assigned_id" INTEGER,
    "first_name" CHAR(64),
    "last_name" CHAR(64),
    "email" CHAR(64),
    "phone" CHAR(32),
    "public" BOOL DEFAULT (1),
    "title" CHAR(64) DEFAULT (99),
    "company" CHAR(64) DEFAULT (99),
    "source" CHAR(32) DEFAULT (99),
    "status" CHAR(10) DEFAULT ('New'),
    "referred_by" CHAR(64) DEFAULT (99),
    "rating" CHAR(5),
    "do_not_call" BOOL,
    "deleted_at" DATETIME,
    "created_at" DATETIME,
    "updated_at" DATETIME,
    "full_name" CHAR(64)
);
INSERT INTO "leads" VALUES(1,1,2,1,'Steven','Harper','steven@gmail.com','','t','99','99','Campaign','Converted','99','***',NULL,NULL,'2012-09-14 21:05:05.823005-0400','2012-10-06 17:42:20.824407-0400','Harper, Steven');
INSERT INTO "leads" VALUES(2,1,NULL,1,'Mitt','Romney','mitt@gmail.com','xx','t','99','99','Campaign','Rejected','99','*',NULL,NULL,'2012-09-27 20:52:04.295814-0400','2012-10-07 14:50:41.703610-0400','Romney, Mitt');
DROP TABLE IF EXISTS "opports";
CREATE TABLE "opports" ("id" INTEGER PRIMARY KEY  NOT NULL ,"user_id" INTEGER,"campaign_id" INTEGER,"assigned_id" INTEGER,"name" char(64),"public" BOOL DEFAULT (1) ,"source" char(32),"stage" char(32),"probability" INTEGER DEFAULT (0) ,"amount" real(12,2) DEFAULT (0) ,"discount" real(12,2) DEFAULT (0) ,"closes_on" DATETIME,"deleted_at" DATETIME,"created_at" DATETIME,"updated_at" DATETIME,"account_id" INTEGER);
INSERT INTO "opports" VALUES(1,1,1,1,'Big Deal','t',NULL,'Prospecting',100,10001.23,0,'2012-09-12 00:00:00.000000-0400',NULL,'2012-09-14 22:01:04.675867-0400','2012-10-07 22:42:00.773685-0400',1);
INSERT INTO "opports" VALUES(2,1,1,1,'Small Deal','t',NULL,'Prospecting',25,2000.02,0,'2012-09-12 00:00:00.000000-0400',NULL,'2012-09-14 22:02:23.130587-0400','2012-10-07 15:02:05.880122-0400',4);
DROP TABLE IF EXISTS "posts";
CREATE TABLE `posts` (`id` integer PRIMARY KEY AUTOINCREMENT, `title` varchar(255) NOT NULL, `body` text NOT NULL, `created_at` timestamp, `updated_at` timestamp, `user_id` integer REFERENCES `users`(`id`) ON DELETE CASCADE ON UPDATE CASCADE);
INSERT INTO "posts" VALUES(7,'This is the first post ...','Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. 
<br><br>
Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. 
<br><br>
Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."','2012-07-07 17:07:44.238180-0400','2012-07-07 17:17:22.326805-0400',1);
INSERT INTO "posts" VALUES(8,'This the second post ...','Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. 
<br><br>
Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. 
<br><br>
Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.','2012-07-07 17:09:20.049775-0400','2012-07-07 17:17:37.100769-0400',1);
INSERT INTO "posts" VALUES(9,'This is the third post ...','Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. 
<br><br>
Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. 
<br><br>
Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.','2012-07-07 17:12:45.778865-0400','2012-07-07 17:17:52.943589-0400',1);
INSERT INTO "posts" VALUES(10,'This is the fourth post','Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. 
<br><br>
Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. 
<br><br>
Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.','2012-07-07 17:13:13.005063-0400','2012-07-07 17:18:12.862166-0400',1);
INSERT INTO "posts" VALUES(11,'This is the fifth post','Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. 
<br><br>
Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. 
<br><br>
Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.','2012-07-07 17:13:47.115463-0400','2012-07-07 17:18:26.819391-0400',1);
DROP TABLE IF EXISTS "tasks";
CREATE TABLE "tasks" ("id" INTEGER PRIMARY KEY  NOT NULL ,"user_id" INTEGER,"assigned_id" INTEGER,"completed_id" INTEGER,"name" varchar(255),"category" char(32),"due_at" DATETIME DEFAULT (0) ,"completed_at" DATETIME,"asset_id" INTEGER DEFAULT (99) ,"asset_type" varchar(255) DEFAULT (99) ,"priority" char(32) DEFAULT (99) ,"bucket" char(32) DEFAULT (99) ,"deleted_at" DATETIME,"created_at" DATETIME,"updated_at" DATETIME,"contact_id" INTEGER,"account_id" INTEGER, "status" char(10) DEFAULT Assigned);
INSERT INTO "tasks" VALUES(1,1,2,NULL,'Need to setup another database record','Email','2012-10-24 00:00:00.000000-0400',NULL,99,'99','Medium','99',NULL,'2012-09-13 20:31:37.476322-0400','2012-10-07 22:28:04.687801-0400',4,4,'Assigned');
INSERT INTO "tasks" VALUES(2,1,1,NULL,'Arrange meeting to discuss','Call','2012-09-14 00:00:00.000000-0400',NULL,99,'99','99','99',NULL,'2012-09-13 20:39:08.963751-0400','2012-09-16 12:08:46.693112-0400',NULL,1,'Completed');
DROP TABLE IF EXISTS "users";
CREATE TABLE "users" ("id" integer PRIMARY KEY ,"email" varchar DEFAULT (null) ,"crypted_password" varchar DEFAULT (null) ,"salt" text DEFAULT (null) ,"username" varchar, "first_name" VARCHAR, "last_name" VARCHAR);
INSERT INTO "users" VALUES(1,'admin','eccbbd2239261f0d16f5ea4810a32b35747c03e9','a1ff7a0ebbd04cd70b1f5f389094b68d46a55a90','Administrator','admin',NULL);
INSERT INTO "users" VALUES(2,'test@gmail.com','8b5c97e38dbbe1416bed0bc90d2b67d6d17dad8b','0245d6ad472ccebcc08d5afbf8403112154659ac','Test User','tester',NULL);
INSERT INTO "users" VALUES(3,'tester@gmail.com','bc9cd357cedba5b39801f116ed90e726fdae2811','6b266174717a8874bd4f5e48749429706586e384','Tester',NULL,NULL);
