# Create a new database* called Remix
CREATE DATABASE IF NOT EXISTS Remix;

# Special MySQL command to show all the databases
# the current user has access to
SHOW DATABASES;

# Set Remix as the current database
# All subsequent db commands will be executed in the
# context of Remix
USE Remix;

# Create the Show table
CREATE TABLE IF NOT EXISTS `Show`
(
    showId          INT,
    title           VARCHAR(40) NOT NULL,
    showFormat      VARCHAR(40),
    debutDate       DATETIME    NOT NULL,
    nextEpDate      DATETIME,
    showStatus      VARCHAR(40),
    showDescription VARCHAR(240),
    views           INT,
    runtime         INT,
    studio          VARCHAR(40) NOT NULL,
    PRIMARY KEY (showId)
);

# Add shows to the Show table
INSERT INTO `Show`
VALUES (1, 'The Fault In Our Stars', 'Movie', '2008-11-11 13:23:44', NULL, 'Finished',
        'This is a movie about love and sickness', 1000000, 158, 'Fox Studios')
     , (2, 'Daybreak', 'TV', '2020-1-10 01:10:42', NULL, 'Finished',
        'This is a movie about teenagers in the apocalypse', 123434, 45, 'Netflix')
     , (3, 'The Bachelorette', 'TV', '2023-3-7 15:40:10', '2023-4-7 15:40:10', 'Running',
        'This is a movie about a woman finding true love', 99999999, 30, 'American Broadcasting Company');

# Create the Content Owner table
CREATE TABLE IF NOT EXISTS `Content Owner`
(
    ownerId   INT,
    ownerName VARCHAR(40),
    type      VARCHAR(40),
    PRIMARY KEY (ownerID)
);

# Add content owners to the Content Owner table
INSERT INTO `Content Owner`
VALUES (1, 'Netflix', 'Streaming Service')
     , (2, 'Fox Studios', 'Producer')
     , (3, 'American Broadcasting Company', 'Broadcasting Service');

# Create the Customer table
CREATE TABLE IF NOT EXISTS Customer
(
    custId     INT,
    firstname  VARCHAR(40),
    lastname   VARCHAR(40),
    emailAddr  VARCHAR(40),
    location   VARCHAR(40) NOT NULL,
    gender     VARCHAR(40) NOT NULL,
    age        INT         NOT NULL,
    username   VARCHAR(40) NOT NULL,
    `password` VARCHAR(40) NOT NULL,
    PRIMARY KEY (custId)
);

# Add customers to the Customer table
INSERT INTO Customer
VALUES (1, 'Spencer', 'Karrat', 'karrat.s@northeastern.edu', 'North America', 'Male', '22', 'skarrat', 'password')
     , (2, 'Zaden', 'Ruggiero-Boune', 'ruggiero-boune.z@northeastern.edu', 'South East Asia', 'Male', '17', 'zrboune',
        'sqlgods')
     , (3, 'Jared', 'Schmitt', 'schmitt.ja@northeastern.edu', 'Central Africa', 'Female', '40', 'jschmitty',
        'hacker123');

# Create the Page Data table
CREATE TABLE IF NOT EXISTS `Page Data`
(
    pageId       INT,
    linksClicked INT,
    visitCount   INT,
    PRIMARY KEY (pageId)
);

# Add data to the Page Data table
INSERT INTO `Page Data`
VALUES (1, 10, 20000)
     , (2, 2, 10)
     , (3, 0, 9999);

# Create the Tag table
CREATE TABLE IF NOT EXISTS Tag
(
    tagId INT,
    label VARCHAR(40),
    PRIMARY KEY (tagId)
);

# Insert tags into the Tag table
INSERT INTO Tag
VALUES (1, 'Horror')
     , (2, 'Action')
     , (3, 'Drama');

# Create the Review table
CREATE TABLE IF NOT EXISTS Review
(
    reviewId      INT,
    firstName     VARCHAR(40),
    lastName      VARCHAR(40),
    reviewComment VARCHAR(240),
    stars         DECIMAL(2, 1),
    showId        INT,
    custId        INT,
    PRIMARY KEY (reviewId),
    CONSTRAINT fk_review_showId
        FOREIGN KEY (showId) REFERENCES `Show` (showId)
            ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_review_custId
        FOREIGN KEY (custId) REFERENCES Customer (custId)
            ON UPDATE CASCADE ON DELETE RESTRICT
);

# Insert reviews into the Review table
INSERT INTO Review
VALUES (1, 'Pam', 'Lolen', 'I think it sucked a lot. Would rate lower if I could.', 0.5, 1, 1)
     , (2, 'Sam', 'Molen', 'It was mid.', 2.5, 1, 2)
     , (3, 'Cam', 'Nolen', 'Probably the best movie I have ever watched. Probably.', 4.5, 1, 3);

# Create the Advertiser table
CREATE TABLE IF NOT EXISTS Advertiser
(
    advertiserId   INT,
    advertiserName VARCHAR(40),
    PRIMARY KEY (advertiserId)
);

# Insert advertisers into the Advertiser table
INSERT INTO Advertiser
VALUES (1, 'Advertising Inc.')
     , (2, 'Movies and Business Company')
     , (3, 'TheBest Company');

# Create the Demographic table
CREATE TABLE IF NOT EXISTS Demographic
(
    demoID   INT,
    gender   VARCHAR(40) NOT NULL,
    age      INT         NOT NULL,
    location VARCHAR(40) NOT NULL,
    PRIMARY KEY (demoID)
);

# Insert demographic data into the Demographic table
INSERT INTO Demographic
VALUES (1, 'Male', 22, 'North America')
     , (2, 'Female', 40, 'Central Africa')
     , (3, 'Female', 17, 'Netherlands');

# Create the Ad table
CREATE TABLE IF NOT EXISTS Ad
(
    adId         INT,
    timeShown    INT,
    clickCount   INT,
    image        BLOB,
    demoID       INT,
    advertiserId INT,
    PRIMARY KEY (adId),
    CONSTRAINT fk_ad_demoId
        FOREIGN KEY (demoId) REFERENCES Demographic (demoID)
            ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_ad_showId
        FOREIGN KEY (advertiserId) REFERENCES Advertiser (advertiserId)
            ON UPDATE CASCADE ON DELETE RESTRICT
);

# Insert ad data into the Ad table
INSERT INTO Ad
VALUES (1, 300, 0, LOAD_FILE('/tmp/toy_story_ad.png'), 2, 1)
     , (2, 666, 66, LOAD_FILE('/tmp/avengers_ad.png'), 1, 3)
     , (3, 1000, 2000, LOAD_FILE('/tmp/walmart_ad.png'), 3, 2);

# Create the Budget table
CREATE TABLE IF NOT EXISTS Budget
(
    budgetId       INT,
    amount         DECIMAL(10, 2),
    budgetInterval INT,
    payment        DECIMAL(10, 2),
    adId           INT,
    PRIMARY KEY (budgetId),
    CONSTRAINT fk_budget_adId
        FOREIGN KEY (adId) REFERENCES Ad (adId)
            ON UPDATE CASCADE ON DELETE RESTRICT
);

# Insert budget data into the Budget table
INSERT INTO Budget
VALUES (1, 20000.00, 30, 200.00, 3)
     , (2, 999.99, 15, 0.00, 2)
     , (3, 10321.23, 365, 5000.00, 1);

# Create the Statistic table
CREATE TABLE IF NOT EXISTS Statistic
(
    statId     INT,
    numViewers INT,
    showId     INT,
    PRIMARY KEY (statId),
    CONSTRAINT fk_stat_showId
        FOREIGN KEY (showId) REFERENCES `Show` (showId)
            ON UPDATE CASCADE ON DELETE RESTRICT
);

# Insert statistic data into the Statistic table
INSERT INTO Statistic
VALUES (1, 300, 3)
     , (2, 0, 2)
     , (3, 20000, 1);

# Create the Platform Statistics table
CREATE TABLE IF NOT EXISTS `Platform Statistics`
(
    platformViews INT,
    platformName  VARCHAR(40),
    statId        INT,
    showId        INT,
    PRIMARY KEY (showId, statId, platformName, platformViews),
    CONSTRAINT fk_plat_stat_statId
        FOREIGN KEY (statId) REFERENCES Statistic (statId)
            ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_plat_stat_showId
        FOREIGN KEY (showId) REFERENCES Statistic (showId)
            ON UPDATE CASCADE ON DELETE RESTRICT
);

# Insert platform statistics data into the Platform Statistics table
INSERT INTO `Platform Statistics`
VALUES (300, 'Netflix', 1, 3)
     , (2000, 'Fox Studios', 2, 2)
     , (0, 'Hulu', 3, 1);

# Create the Device Statistics table
CREATE TABLE IF NOT EXISTS `Device Statistics`
(
    deviceModel VARCHAR(40),
    deviceType  VARCHAR(40),
    deviceViews INT,
    statId      INT,
    showId      INT,
    PRIMARY KEY (showId, statId, deviceModel, deviceType, deviceViews),
    CONSTRAINT fk_dev_stat_statId
        FOREIGN KEY (statId) REFERENCES Statistic (statId)
            ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_dev_stat_showId
        FOREIGN KEY (showId) REFERENCES Statistic (showId)
            ON UPDATE CASCADE ON DELETE RESTRICT
);

# Insert device statistics data into the Device Statistics table
INSERT INTO `Device Statistics`
VALUES ('iPhone', 'phone', 300, 1, 3)
     , ('Samsung Galaxy Tablet', 'tablet', 2000, 2, 2)
     , ('Chromebook', 'laptop', 0, 3, 1);

#Create bridge table between Content Owner and Show called 'Owner To Show'
CREATE TABLE IF NOT EXISTS `Owner To Show`
(
    showId  INT,
    ownerId INT,
    PRIMARY KEY (showId, ownerId),
    CONSTRAINT fk_owner_to_show_showId
        FOREIGN KEY (showId) REFERENCES `Show` (showId)
            ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_owner_to_show_ownerId
        FOREIGN KEY (ownerId) REFERENCES `Content Owner` (ownerId)
            ON UPDATE CASCADE ON DELETE RESTRICT
);

# Insert join data into Owner To Show table
INSERT INTO `Owner To Show`
VALUES (1, 2)
     , (2, 1)
     , (3, 3);

#Create bridge table between Ad and Page called 'Ad To Page'
CREATE TABLE IF NOT EXISTS `Ad To Page Data`
(
    adId   INT,
    pageId INT,
    PRIMARY KEY (adId, pageId),
    CONSTRAINT fk_ad_to_page_data_adId
        FOREIGN KEY (adId) REFERENCES Ad (adId)
            ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_ad_to_page_data_pageId
        FOREIGN KEY (pageId) REFERENCES `Page Data` (pageId)
            ON UPDATE CASCADE ON DELETE RESTRICT
);

# Insert join data into Ad To Page Data table
INSERT INTO `Ad To Page Data`
VALUES (1, 1)
     , (2, 2)
     , (3, 3);

#Create bridge table between Ad and Tag called 'Ad To Tag'
CREATE TABLE IF NOT EXISTS `Ad To Tag`
(
    adId  INT,
    tagId INT,
    PRIMARY KEY (adId, tagId),
    CONSTRAINT fk_ad_att
        FOREIGN KEY (adId) REFERENCES Ad (adId)
            ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_tag_att
        FOREIGN KEY (tagId) REFERENCES Tag (tagId)
            ON UPDATE CASCADE ON DELETE RESTRICT
);

# Insert join data into Ad To Page Data table
INSERT INTO `Ad To Tag`
VALUES (1, 1),
       (2, 2),
       (3, 3);

#Create bridge table between Show and Tag called 'Show To Tag'
CREATE TABLE IF NOT EXISTS `Show To Tag`
(
    showId INT,
    tagId  INT,
    PRIMARY KEY (showId, tagId),
    CONSTRAINT fk_show_stt
        FOREIGN KEY (showId) REFERENCES `Show` (showId)
            ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_tag_stt
        FOREIGN KEY (tagId) REFERENCES Tag (tagId)
            ON UPDATE CASCADE ON DELETE RESTRICT
);

# Insert join data into Show To Tag table
INSERT INTO `Show To Tag`
VALUES (1, 1),
       (2, 2),
       (3, 3);

#Create bridge table between Show and Customer called 'Show To Customer'
CREATE TABLE IF NOT EXISTS `Show To Customer`
(
    showId INT,
    custId INT,
    PRIMARY KEY (showId, custId),
    CONSTRAINT fk_show_cts
        FOREIGN KEY (showId) REFERENCES `Show` (showID)
            ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_cust_cts
        FOREIGN KEY (custID) REFERENCES Customer (custId)
            ON UPDATE CASCADE ON DELETE RESTRICT
);

# Insert join data into Show To Customer table
INSERT INTO `Show To Customer`
VALUES (1, 1),
       (2, 2),
       (3, 3);