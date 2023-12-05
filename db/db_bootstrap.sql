create database Tailored;

grant all privileges on Tailored.* to 'root'@'%';
flush privileges;

USE Tailored;

CREATE TABLE IF NOT EXISTS Shipping_Option (
    ShippingOptionID int AUTO_INCREMENT PRIMARY KEY,
    Cost decimal(4, 2) NOT NULL,
    Duration varchar(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS Shopping_Cart(
    CartID int AUTO_INCREMENT PRIMARY KEY,
    Cost decimal(10,2) NOT NULL,
    ItemID int NOT NULL,
    ShippingOptionID int NOT NULL,
    FOREIGN KEY (ShippingOptionID) REFERENCES Shipping_Option(ShippingOptionID)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS User(
    UserID int AUTO_INCREMENT PRIMARY KEY,
    FirstName varchar(100) NOT NULL,
    LastName varchar(100) NOT NULL,
    CartID int NOT NULL,
    FOREIGN KEY (CartID) REFERENCES Shopping_Cart(CartID)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Persona(
    PersonaID int AUTO_INCREMENT PRIMARY KEY,
    Age int NOT NULL,
    Gender varchar(10) NOT NULL,
    StylePreference varchar(100) NOT NULL,
    UserID int NOT NULL,
    FOREIGN KEY (UserID) REFERENCES User(UserID)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Payment_Option(
    PaymentOptionID int AUTO_INCREMENT PRIMARY KEY,
    Type varchar(50) NOT NULL,
    CartID int NOT NULL,
    FOREIGN KEY(CartID) REFERENCES Shopping_Cart(CartID)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Card_Info(
    CardNumber varchar(30) PRIMARY KEY,
    CVC int NOT NULL,
    NameOnCard varchar(200) NOT NULL,
    PaymentOptionID int NOT NULL,
    FOREIGN KEY (PaymentOptionID) REFERENCES Payment_Option(PaymentOptionID)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS Shipping_Info (
    ShippingInfoID int AUTO_INCREMENT PRIMARY KEY,
    Name varchar(200),
    Street varchar(75) NOT NULL,
    City varchar(75) NOT NULL,
    State char(2) NOT NULL,
    ZipCode char(5) NOT NULL,
    ShippingOptionID int,
    FOREIGN KEY (ShippingOptionID) REFERENCES Shipping_Option(ShippingOptionID)
        ON UPDATE cascade ON DELETE cascade
);

CREATE TABLE IF NOT EXISTS ShippingInfo_User (
    UserID int NOT NULL,
    ShippingInfoID int NOT NULL,
    PRIMARY KEY (UserID, ShippingInfoID),
    FOREIGN KEY (UserID) REFERENCES User(UserID)
        ON UPDATE cascade ON DELETE cascade,
    FOREIGN KEY (ShippingInfoID) REFERENCES Shipping_Info(ShippingInfoID)
        ON UPDATE cascade ON DELETE cascade
);

CREATE TABLE IF NOT EXISTS Notifications (
    NotificationID int AUTO_INCREMENT PRIMARY KEY,
    SubjectLine varchar(100) NOT NULL,
    Messages text,
    TimeStamp datetime DEFAULT CURRENT_TIMESTAMP NOT NULL
);

CREATE TABLE IF NOT EXISTS User_Notif (
    UserID int NOT NULL,
    NotificationID int NOT NULL,
    PRIMARY KEY (UserID, NotificationID),
    FOREIGN KEY (UserID) REFERENCES User(UserID)
        ON UPDATE cascade ON DELETE cascade,
    FOREIGN KEY (NotificationID) REFERENCES Notifications(NotificationID)
        ON UPDATE cascade ON DELETE cascade
);

CREATE TABLE IF NOT EXISTS Wishlist (
    WishlistID int AUTO_INCREMENT PRIMARY KEY,
    Name varchar(100) NOT NULL,
    UserID int NOT NULL,
    FOREIGN KEY (UserID) REFERENCES User(UserID)
        ON UPDATE cascade ON DELETE cascade
);

CREATE TABLE Category (
    CategoryID int AUTO_INCREMENT PRIMARY KEY,
    Material varchar(75),
    CategoryName varchar(75) NOT NULL
);

CREATE TABLE IF NOT EXISTS Discount (
    DiscountID int AUTO_INCREMENT PRIMARY KEY,
    Name varchar(75) NOT NULL,
    Amount decimal(10, 2) NOT NULL,
    Description text
);

CREATE TABLE IF NOT EXISTS Style (
    StyleID int AUTO_INCREMENT PRIMARY KEY,
    Color varchar(50) NOT NULL,
    AestheticName varchar(75) NOT NULL,
    TrendRating int NOT NULL CHECK (TrendRating BETWEEN 0 AND 10)
);

CREATE TABLE IF NOT EXISTS Brand (
    Name varchar(100) PRIMARY KEY,
    Rating int NOT NULL CHECK (Rating BETWEEN 0 AND 10),
    Type varchar(75) NOT NULL
);

CREATE TABLE IF NOT EXISTS Clothing_Item (
    ItemID int AUTO_INCREMENT PRIMARY KEY,
    Size varchar(3) NOT NULL,
    Name varchar(75) NOT NULL,
    Description text,
    Price decimal(10, 2) NOT NULL,
    DiscountID int,
    CategoryID int NOT NULL,
    CartID int,
    BrandName varchar(75) NOT NULL,
    StyleID int NOT NULL,
    FOREIGN KEY (DiscountID) REFERENCES Discount (DiscountID)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (CategoryID) REFERENCES Category (CategoryID)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (CartID) REFERENCES Shopping_Cart (CartID)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (BrandName) REFERENCES Brand (Name)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (StyleID) REFERENCES Style (StyleID)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Purchase_History (
    PurchaseHistoryID int AUTO_INCREMENT PRIMARY KEY,
    PurchaseDate datetime DEFAULT CURRENT_TIMESTAMP NOT NULL,
    PurchaseCost decimal(10, 2) NOT NULL,
    PurchaseAesthetic varchar(75),
    UserID int NOT NULL,
    FOREIGN KEY (UserID) REFERENCES User (UserID)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Outfit (
    OutfitID int AUTO_INCREMENT PRIMARY KEY,
    Style varchar(75) NOT NULL,
    BodyFit varchar(75) NOT NULL,
    Price decimal(10, 2) NOT NULL,
    CostRating varchar(3),
    Name varchar(75) NOT NULL,
    UserID int NOT NULL,
    FOREIGN KEY (UserID) REFERENCES User (UserID)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS PurchaseHistory_Outfit (
    PurchaseHistoryID int NOT NULL,
    OutfitID int NOT NULL,
    PRIMARY KEY (PurchaseHistoryID, OutfitID),
    FOREIGN KEY (PurchaseHistoryID) REFERENCES Purchase_History (PurchaseHistoryID)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (OutfitID) REFERENCES Outfit (OutfitID)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Item_Outfit (
    ItemID int NOT NULL,
    OutfitID int NOT NULL,
    PRIMARY KEY (ItemID, OutfitID),
    FOREIGN KEY (ItemID) REFERENCES Clothing_Item (ItemID)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (OutfitID) REFERENCES Outfit (OutfitID)
        ON UPDATE CASCADE ON DELETE CASCADE
);


/* Insert data */

/* Insert Shipping Options */
insert into Shipping_Option (Cost, Duration) values (4.99, 'Standard Shipping - 5 business days');
insert into Shipping_Option (Cost, Duration) values (9.99, 'Expedited Shipping - 2 business days');
insert into Shipping_Option (Cost, Duration) values (14.99, 'Overnight Shipping');
insert into Shipping_Option (Cost, Duration) values (8.99, 'Standard International Shipping - 7 business days');
insert into Shipping_Option (Cost, Duration) values (20.99, 'Expedited International Shipping - 3 business days');
insert into Shipping_Option (Cost, Duration) values (3.99, 'Expedited Shipping Selected Areas');
insert into Shipping_Option (Cost, Duration) values (2.99, 'Standard Shipping Selected Areas');

/* Insert Shopping Carts */
insert into Shopping_Cart ( Cost, ItemID, ShippingOptionID) values ( 99.12, 40, '7');
insert into Shopping_Cart ( Cost, ItemID, ShippingOptionID) values ( 182.55, 3, '5');
insert into Shopping_Cart ( Cost, ItemID, ShippingOptionID) values ( 67.80, 8, '2');
insert into Shopping_Cart ( Cost, ItemID, ShippingOptionID) values ( 55.99, 9, '6');
insert into Shopping_Cart ( Cost, ItemID, ShippingOptionID) values ( 35.99, 16, '1');
insert into Shopping_Cart ( Cost, ItemID, ShippingOptionID) values ( 74.50, 26, '3');
insert into Shopping_Cart ( Cost, ItemID, ShippingOptionID) values ( 59.30, 9, '4');
insert into Shopping_Cart ( Cost, ItemID, ShippingOptionID) values ( 157.75, 23, '1');
insert into Shopping_Cart ( Cost, ItemID, ShippingOptionID) values ( 24.95, 7, '7');
insert into Shopping_Cart ( Cost, ItemID, ShippingOptionID) values ( 28.18, 6, '2');
insert into Shopping_Cart ( Cost, ItemID, ShippingOptionID) values ( 96.88, 10, '5');
insert into Shopping_Cart ( Cost, ItemID, ShippingOptionID) values ( 68.01, 15, '6');
insert into Shopping_Cart ( Cost, ItemID, ShippingOptionID) values ( 48.50, 17, '4');
insert into Shopping_Cart ( Cost, ItemID, ShippingOptionID) values ( 57.04, 25, '3');
insert into Shopping_Cart ( Cost, ItemID, ShippingOptionID) values ( 55.64, 38, '1');
insert into Shopping_Cart ( Cost, ItemID, ShippingOptionID) values ( 28.08, 2, '6');
insert into Shopping_Cart ( Cost, ItemID, ShippingOptionID) values ( 120.55, 14, '7');
insert into Shopping_Cart ( Cost, ItemID, ShippingOptionID) values ( 18.65, 39, '2');
insert into Shopping_Cart ( Cost, ItemID, ShippingOptionID) values ( 51.75, 18, '5');
insert into Shopping_Cart ( Cost, ItemID, ShippingOptionID) values ( 123.05, 12, '4');
insert into Shopping_Cart ( Cost, ItemID, ShippingOptionID) values ( 33.50, 29, '3');
insert into Shopping_Cart ( Cost, ItemID, ShippingOptionID) values ( 13.35, 24, '2');
insert into Shopping_Cart ( Cost, ItemID, ShippingOptionID) values ( 75.99, 36, '1');
insert into Shopping_Cart ( Cost, ItemID, ShippingOptionID) values ( 18.23, 34, '6');
insert into Shopping_Cart ( Cost, ItemID, ShippingOptionID) values ( 09.25, 13, '7');
insert into Shopping_Cart ( Cost, ItemID, ShippingOptionID) values ( 71.69, 15, '3');
insert into Shopping_Cart ( Cost, ItemID, ShippingOptionID) values ( 42.69, 23, '4');
insert into Shopping_Cart ( Cost, ItemID, ShippingOptionID) values ( 100.50, 37, '5');
insert into Shopping_Cart ( Cost, ItemID, ShippingOptionID) values ( 66.90, 40, '3');
insert into Shopping_Cart ( Cost, ItemID, ShippingOptionID) values ( 26.00, 31, '6');
insert into Shopping_Cart ( Cost, ItemID, ShippingOptionID) values ( 51.55, 23, '1');
insert into Shopping_Cart ( Cost, ItemID, ShippingOptionID) values ( 16.90, 32, '5');
insert into Shopping_Cart ( Cost, ItemID, ShippingOptionID) values ( 213.35, 24, '4');
insert into Shopping_Cart ( Cost, ItemID, ShippingOptionID) values ( 45.95, 15, '7');
insert into Shopping_Cart ( Cost, ItemID, ShippingOptionID) values ( 35.99, 16, '2');
insert into Shopping_Cart ( Cost, ItemID, ShippingOptionID) values ( 40.92, 2, '1');
insert into Shopping_Cart ( Cost, ItemID, ShippingOptionID) values ( 17.63, 13, '7');
insert into Shopping_Cart ( Cost, ItemID, ShippingOptionID) values ( 39.00, 26, '3');
insert into Shopping_Cart ( Cost, ItemID, ShippingOptionID) values ( 19.13, 33, '6');
insert into Shopping_Cart ( Cost, ItemID, ShippingOptionID) values ( 97.50, 36, '2');

/* Insert Users */
insert into User (FirstName, LastName, CartID) values ('Amanda', 'Lee', '1');
insert into User (FirstName, LastName, CartID) values ('Siya', 'Patel', '2');
insert into User (FirstName, LastName, CartID) values ('Celine', 'Hapke', '3');
insert into User (FirstName, LastName, CartID) values ('Reuben', 'Syson', '4');
insert into User (FirstName, LastName, CartID) values ('Isabelle', 'Bissett', '5');
insert into User (FirstName, LastName, CartID) values ('Noelyn', 'Feighney', '6');
insert into User (FirstName, LastName, CartID) values ('Lizzie', 'Domniney', '7');
insert into User (FirstName, LastName, CartID) values ('Caroljean', 'Mullally', '8');
insert into User (FirstName, LastName, CartID) values ('Lynn', 'Jenteau', '9');
insert into User (FirstName, LastName, CartID) values ('Quintin', 'Tuffin', '10');
insert into User (FirstName, LastName, CartID) values ('Dan', 'Park', '11');
insert into User (FirstName, LastName, CartID) values ('Rea', 'Shingfield', '12');
insert into User (FirstName, LastName, CartID) values ('Maurice', 'Monier', '13');
insert into User (FirstName, LastName, CartID) values ('Arya', 'Gupta', '14');
insert into User (FirstName, LastName, CartID) values ('Robbie', 'Craxford', '15');
insert into User (FirstName, LastName, CartID) values ('Doris', 'Lee', '16');
insert into User (FirstName, LastName, CartID) values ('Merell', 'Caig', '17');
insert into User (FirstName, LastName, CartID) values ('Kevin', 'Amori', '18');
insert into User (FirstName, LastName, CartID) values ('Alica', 'Pawelczyk', '19');
insert into User (FirstName, LastName, CartID) values ('Findlay', 'Kybird', '20');
insert into User (FirstName, LastName, CartID) values ('Jacquelin', 'Li', '21');
insert into User (FirstName, LastName, CartID) values ('Darcy', 'Barrack', '22');
insert into User (FirstName, LastName, CartID) values ('Rica', 'Teodorski', '23');
insert into User (FirstName, LastName, CartID) values ('Garreth', 'Yakutin', '24');
insert into User (FirstName, LastName, CartID) values ('Dorris', 'McGrotty', '25');
insert into User (FirstName, LastName, CartID) values ('Tandi', 'Haysar', '26');
insert into User (FirstName, LastName, CartID) values ('Sheila', 'Brea', '27');
insert into User (FirstName, LastName, CartID) values ('Jemimah', 'Trevear', '28');
insert into User (FirstName, LastName, CartID) values ('Tina', 'Wan', '29');
insert into User (FirstName, LastName, CartID) values ('Madelena', 'O''Flynn', '30');
insert into User (FirstName, LastName, CartID) values ('Chance', 'Ockland', '31');
insert into User (FirstName, LastName, CartID) values ('Jolynn', 'Wang', '32');
insert into User (FirstName, LastName, CartID) values ('Karrie', 'Deporte', '33');
insert into User (FirstName, LastName, CartID) values ('Cariotta', 'Antos', '34');
insert into User (FirstName, LastName, CartID) values ('Franciska', 'Keniwell', '35');
insert into User (FirstName, LastName, CartID) values ('Andrew', 'Kim', '36');
insert into User (FirstName, LastName, CartID) values ('Peter', 'Fulford', '37');
insert into User (FirstName, LastName, CartID) values ('Melinde', 'Mugford', '38');
insert into User (FirstName, LastName, CartID) values ('Win', 'Pinckney', '39');
insert into User (FirstName, LastName, CartID) values ('Margaretha', 'Croxford', '40');

/* Insert Persona */
insert into Persona (Age, Gender, StylePreference, UserID) values (20, 'Female', 'Vintage', '22');
insert into Persona (Age, Gender, StylePreference, UserID) values (42, 'Female', 'Quiet Luxury', '2');
insert into Persona (Age, Gender, StylePreference, UserID) values (16, 'Female', 'Cottagecore', '12');
insert into Persona (Age, Gender, StylePreference, UserID) values (57, 'Female', 'Clean', '33');
insert into Persona (Age, Gender, StylePreference, UserID) values (24, 'Female', 'Grunge', '6');
insert into Persona (Age, Gender, StylePreference, UserID) values (24, 'Male', 'Gorpcore', '13');
insert into Persona (Age, Gender, StylePreference, UserID) values (17, 'Male', 'Academia', '36');
insert into Persona (Age, Gender, StylePreference, UserID) values (54, 'Female', 'Quiet Luxury', '1');
insert into Persona (Age, Gender, StylePreference, UserID) values (32, 'Male', 'Clean', '34');
insert into Persona (Age, Gender, StylePreference, UserID) values (28, 'Female', 'Vintage', '24');
insert into Persona (Age, Gender, StylePreference, UserID) values (25, 'Male', 'Gorpcore', '11');
insert into Persona (Age, Gender, StylePreference, UserID) values (45, 'Male', 'Quiet Luxury', '18');
insert into Persona (Age, Gender, StylePreference, UserID) values (19, 'Female', 'Coquette', '5');
insert into Persona (Age, Gender, StylePreference, UserID) values (29, 'Male', 'Vintage', '26');
insert into Persona (Age, Gender, StylePreference, UserID) values (19, 'Male', 'Grunge', '8');
insert into Persona (Age, Gender, StylePreference, UserID) values (26, 'Male', 'Quiet Luxury', '40');
insert into Persona (Age, Gender, StylePreference, UserID) values (24, 'Male', 'Streetwear', '16');
insert into Persona (Age, Gender, StylePreference, UserID) values (38, 'Female', 'Clean', '37');
insert into Persona (Age, Gender, StylePreference, UserID) values (20, 'Female', 'Coquette', '7');
insert into Persona (Age, Gender, StylePreference, UserID) values (28, 'Male', 'Streetwear', '35');
insert into Persona (Age, Gender, StylePreference, UserID) values (20, 'Female', 'Cottagecore', '14');
insert into Persona (Age, Gender, StylePreference, UserID) values (15, 'Female', 'Academia', '10');
insert into Persona (Age, Gender, StylePreference, UserID) values (29, 'Female', 'Quiet Luxury', '28');
insert into Persona (Age, Gender, StylePreference, UserID) values (37, 'Male', 'Clean', '19');
insert into Persona (Age, Gender, StylePreference, UserID) values (24, 'Male', 'Streetwear', '3');
insert into Persona (Age, Gender, StylePreference, UserID) values (28, 'Male', 'Gorpcore', '32');
insert into Persona (Age, Gender, StylePreference, UserID) values (18, 'Female', 'Y2K', '20');
insert into Persona (Age, Gender, StylePreference, UserID) values (24, 'Female', 'Y2K', '30');
insert into Persona (Age, Gender, StylePreference, UserID) values (18, 'Male', 'Streetwear', '17');
insert into Persona (Age, Gender, StylePreference, UserID) values (25, 'Female', 'Y2K', '39');
insert into Persona (Age, Gender, StylePreference, UserID) values (17, 'Male', 'Gorpcore', '29');
insert into Persona (Age, Gender, StylePreference, UserID) values (42, 'Male', 'Academia', '4');
insert into Persona (Age, Gender, StylePreference, UserID) values (26, 'Female', 'Clean', '23');
insert into Persona (Age, Gender, StylePreference, UserID) values (31, 'Female', 'Quiet Luxury', '38');
insert into Persona (Age, Gender, StylePreference, UserID) values (24, 'Female', 'Y2K', '21');
insert into Persona (Age, Gender, StylePreference, UserID) values (39, 'Female', 'Quiet Luxury', '31');
insert into Persona (Age, Gender, StylePreference, UserID) values (23, 'Male', 'Y2K', '27');
insert into Persona (Age, Gender, StylePreference, UserID) values (35, 'Female', 'Clean', '25');
insert into Persona (Age, Gender, StylePreference, UserID) values (34, 'Male', 'Vintage', '9');
insert into Persona (Age, Gender, StylePreference, UserID) values (47, 'Female', 'Vintage', '15');

/* Insert Payment Options */
insert into Payment_Option (Type, CartID) values ('debit card', '29');
insert into Payment_Option (Type, CartID) values ('debit card', '30');
insert into Payment_Option (Type, CartID) values ('debit card', '11');
insert into Payment_Option (Type, CartID) values ('debit card', '26');
insert into Payment_Option (Type, CartID) values ('cash on delivery', '37');
insert into Payment_Option (Type, CartID) values ('credit card', '15');
insert into Payment_Option (Type, CartID) values ('credit card', '23');
insert into Payment_Option (Type, CartID) values ('debit card', '19');
insert into Payment_Option (Type, CartID) values ('cash on delivery', '8');
insert into Payment_Option (Type, CartID) values ('cash on delivery', '33');
insert into Payment_Option (Type, CartID) values ('debit card', '13');
insert into Payment_Option (Type, CartID) values ('credit card', '6');
insert into Payment_Option (Type, CartID) values ('cash on delivery', '4');
insert into Payment_Option (Type, CartID) values ('credit card', '34');
insert into Payment_Option (Type, CartID) values ('credit card', '10');
insert into Payment_Option (Type, CartID) values ('credit card', '22');
insert into Payment_Option (Type, CartID) values ('cash on delivery', '38');
insert into Payment_Option (Type, CartID) values ('debit card', '24');
insert into Payment_Option (Type, CartID) values ('debit card', '21');
insert into Payment_Option (Type, CartID) values ('credit card', '12');
insert into Payment_Option (Type, CartID) values ('debit card', '2');
insert into Payment_Option (Type, CartID) values ('credit card', '20');
insert into Payment_Option (Type, CartID) values ('credit card', '16');
insert into Payment_Option (Type, CartID) values ('credit card', '27');
insert into Payment_Option (Type, CartID) values ('cash on delivery', '32');
insert into Payment_Option (Type, CartID) values ('debit card', '7');
insert into Payment_Option (Type, CartID) values ('credit card', '28');
insert into Payment_Option (Type, CartID) values ('debit card', '5');
insert into Payment_Option (Type, CartID) values ('debit card', '14');
insert into Payment_Option (Type, CartID) values ('credit card', '1');
insert into Payment_Option (Type, CartID) values ('cash on delivery', '35');
insert into Payment_Option (Type, CartID) values ('credit card', '40');
insert into Payment_Option (Type, CartID) values ('debit card', '36');
insert into Payment_Option (Type, CartID) values ('cash on delivery', '31');
insert into Payment_Option (Type, CartID) values ('credit card', '9');
insert into Payment_Option (Type, CartID) values ('debit card', '25');
insert into Payment_Option (Type, CartID) values ('credit card', '3');
insert into Payment_Option (Type, CartID) values ('credit card', '18');
insert into Payment_Option (Type, CartID) values ('debit card', '17');
insert into Payment_Option (Type, CartID) values ('debit card', '39');

/* Insert Card Info */
insert into Card_Info (CardNumber, CVC, NameOnCard, PaymentOptionID) values ('5038040599589705787', '529', 'Caroljean Mullally', '13');
insert into Card_Info (CardNumber, CVC, NameOnCard, PaymentOptionID) values ('3537941163622021', '231', 'Madelena O''Flynn', '25');
insert into Card_Info (CardNumber, CVC, NameOnCard, PaymentOptionID) values ('3549720131783495', '108', 'Reuben Syson', '19');
insert into Card_Info (CardNumber, CVC, NameOnCard, PaymentOptionID) values ('3588886248061760', '010', 'Andrew Kim', '20');
insert into Card_Info (CardNumber, CVC, NameOnCard, PaymentOptionID) values ('5100145340131391', '776', 'Amanda Lee', '21');
insert into Card_Info (CardNumber, CVC, NameOnCard, PaymentOptionID) values ('3573620077062897', '076', 'Peter Fulford', '24');
insert into Card_Info (CardNumber, CVC, NameOnCard, PaymentOptionID) values ('30382277943011', '936', 'Tandi Haysar', '37');
insert into Card_Info (CardNumber, CVC, NameOnCard, PaymentOptionID) values ('3579238464999532', '518', 'Jolynn Wang', '9');
insert into Card_Info (CardNumber, CVC, NameOnCard, PaymentOptionID) values ('5602216713864851', '954', 'Garreth Yukatin', '17');
insert into Card_Info (CardNumber, CVC, NameOnCard, PaymentOptionID) values ('5273184114967541', '198', 'Arya Gupta', '36');
insert into Card_Info (CardNumber, CVC, NameOnCard, PaymentOptionID) values ('5255802189127665', '101', 'Rea Shingfield', '6');
insert into Card_Info (CardNumber, CVC, NameOnCard, PaymentOptionID) values ('3586017096615620', '177', 'Darcy Barrack', '22');
insert into Card_Info (CardNumber, CVC, NameOnCard, PaymentOptionID) values ('5470235471670481', '131', 'Dorris Lee', '1');
insert into Card_Info (CardNumber, CVC, NameOnCard, PaymentOptionID) values ('5403918557866907', '755', 'Siya Patel', '16');
insert into Card_Info (CardNumber, CVC, NameOnCard, PaymentOptionID) values ('3558844648413244', '300', 'Findlay Kybird', '34');
insert into Card_Info (CardNumber, CVC, NameOnCard, PaymentOptionID) values ('337941156486127', '923', 'Cariotta Antos', '4');
insert into Card_Info (CardNumber, CVC, NameOnCard, PaymentOptionID) values ('3589901176570010', '635', 'Isabelle Bissett', '32');
insert into Card_Info (CardNumber, CVC, NameOnCard, PaymentOptionID) values ('5002358354224809', '205', 'Tina Wan', '35');
insert into Card_Info (CardNumber, CVC, NameOnCard, PaymentOptionID) values ('4017954210142', '319', 'Franciska Keniwell', '2');
insert into Card_Info (CardNumber, CVC, NameOnCard, PaymentOptionID) values ('3585840477759696', '901', 'Alica Pawelczyk', '28');
insert into Card_Info (CardNumber, CVC, NameOnCard, PaymentOptionID) values ('3581270366192904', '645', 'Melinde Mugford', '18');
insert into Card_Info (CardNumber, CVC, NameOnCard, PaymentOptionID) values ('201605047008910', '687', 'Robbie Craxford', '10');
insert into Card_Info (CardNumber, CVC, NameOnCard, PaymentOptionID) values ('3559430633138787', '816', 'Lizzie Domniney', '11');
insert into Card_Info (CardNumber, CVC, NameOnCard, PaymentOptionID) values ('5223845484817380', '451', 'Rica Teodoski', '38');
insert into Card_Info (CardNumber, CVC, NameOnCard, PaymentOptionID) values ('6771670631640235280', '048', 'Win Pinckney', '40');
insert into Card_Info (CardNumber, CVC, NameOnCard, PaymentOptionID) values ('4936827425954712965', '855', 'Chance Ockland', '3');
insert into Card_Info (CardNumber, CVC, NameOnCard, PaymentOptionID) values ('5641823437407050355', '852', 'Dan Park', '12');
insert into Card_Info (CardNumber, CVC, NameOnCard, PaymentOptionID) values ('3589226233269343', '411', 'Dorris McGrotty', '30');
insert into Card_Info (CardNumber, CVC, NameOnCard, PaymentOptionID) values ('3550373546478131', '932', 'Jemimah Travear', '5');
insert into Card_Info (CardNumber, CVC, NameOnCard, PaymentOptionID) values ('3573964858287178', '535', 'Maurice Monier', '29');
insert into Card_Info (CardNumber, CVC, NameOnCard, PaymentOptionID) values ('3579421845146946', '886', 'Jacquelin Li', '15');
insert into Card_Info (CardNumber, CVC, NameOnCard, PaymentOptionID) values ('3569465915411856', '441', 'Noelyn Feighney', '26');
insert into Card_Info (CardNumber, CVC, NameOnCard, PaymentOptionID) values ('3572833647282231', '468', 'Quintin Tuffin', '14');
insert into Card_Info (CardNumber, CVC, NameOnCard, PaymentOptionID) values ('3535416588753687', '491', 'Celine Hepke', '27');
insert into Card_Info (CardNumber, CVC, NameOnCard, PaymentOptionID) values ('30580202809872', '645', 'Karrie Deporte', '23');
insert into Card_Info (CardNumber, CVC, NameOnCard, PaymentOptionID) values ('4017958389017', '049', 'Lynn Jenteau', '7');
insert into Card_Info (CardNumber, CVC, NameOnCard, PaymentOptionID) values ('3581766655754700', '724', 'Sheila Brea', '33');
insert into Card_Info (CardNumber, CVC, NameOnCard, PaymentOptionID) values ('5048376537241181', '607', 'Merell Caig', '31');
insert into Card_Info (CardNumber, CVC, NameOnCard, PaymentOptionID) values ('3565886128335489', '117', 'Magaretha Croxford', '8');
insert into Card_Info (CardNumber, CVC, NameOnCard, PaymentOptionID) values ('3564865885150696', '019', 'Kevin Amori', '39');

/* Insert Shipping Info */
insert into Shipping_Info (Name, Street, City, State, ZipCode, ShippingOptionID) values ('My house', '678 Union Center', 'Portland', 'OR', '97271', '7');
insert into Shipping_Info (Name, Street, City, State, ZipCode, ShippingOptionID) values ('Garreth home', '506 Shoshone Avenue', 'Murfreesboro', 'TN', '37131', '6');
insert into Shipping_Info (Name, Street, City, State, ZipCode, ShippingOptionID) values ('Home', '41860 Sutteridge Court', 'Falls Church', 'VA', '22047', '5');
insert into Shipping_Info (Name, Street, City, State, ZipCode, ShippingOptionID) values ('Office', '6925 Northwestern Drive', 'El Paso', 'TX', '88569', '3');
insert into Shipping_Info (Name, Street, City, State, ZipCode, ShippingOptionID) values ('My apartment', '46 Fieldstone Hill', 'Montpelier', 'VT', '05609', '1');
insert into Shipping_Info (Name, Street, City, State, ZipCode, ShippingOptionID) values ('Win''s home', '0 Forest Park', 'Lancaster', 'PA', '17605', '2');
insert into Shipping_Info (Name, Street, City, State, ZipCode, ShippingOptionID) values ('College', '71 Talmadge Court', 'San Diego', 'CA', '92121', '4');
insert into Shipping_Info (Name, Street, City, State, ZipCode, ShippingOptionID) values ('Dorm', '215 Karstens Avenue', 'Lincoln', 'NE', '68583', '2');
insert into Shipping_Info (Name, Street, City, State, ZipCode, ShippingOptionID) values ('Teodorski house', '44 Boyd Circle', 'Bakersfield', 'CA', '93311', '5');
insert into Shipping_Info (Name, Street, City, State, ZipCode, ShippingOptionID) values ('My college dorm', '0087 Brown Way', 'Memphis', 'TN', '38150', '1');
insert into Shipping_Info (Name, Street, City, State, ZipCode, ShippingOptionID) values ('My house', '47 Dakota Road', 'Kansas City', 'MO', '64101', '6');
insert into Shipping_Info (Name, Street, City, State, ZipCode, ShippingOptionID) values ('Office', '295 Westerfield Alley', 'Los Angeles', 'CA', '90060', '7');
insert into Shipping_Info (Name, Street, City, State, ZipCode, ShippingOptionID) values ('Apartment', '8 Crownhardt Way', 'Ocala', 'FL', '34479', '4');
insert into Shipping_Info (Name, Street, City, State, ZipCode, ShippingOptionID) values ('Dorm', '61176 Knutson Trail', 'Great Neck', 'NY', '11024', '3');
insert into Shipping_Info (Name, Street, City, State, ZipCode, ShippingOptionID) values ('Mailroom', '90 Bultman Lane', 'Saint Paul', 'MN', '55115', '2');
insert into Shipping_Info (Name, Street, City, State, ZipCode, ShippingOptionID) values ('My apartment', '1 Tennyson Crossing', 'Des Moines', 'IA', '50335', '4');
insert into Shipping_Info (Name, Street, City, State, ZipCode, ShippingOptionID) values ('Rica''s apartment', '689 Arkansas Center', 'Scranton', 'PA', '18505', '5');
insert into Shipping_Info (Name, Street, City, State, ZipCode, ShippingOptionID) values ('Peter''s room', '4 Hanover Pass', 'Fort Worth', 'TX', '76110', '3');
insert into Shipping_Info (Name, Street, City, State, ZipCode, ShippingOptionID) values ('My house', '88 Talmadge Park', 'Billings', 'MT', '59105', '6');
insert into Shipping_Info (Name, Street, City, State, ZipCode, ShippingOptionID) values ('Parent''s house', '95027 Little Fleur Drive', 'Buffalo', 'NY', '14225', '1');
insert into Shipping_Info (Name, Street, City, State, ZipCode, ShippingOptionID) values ('Home', '4 Waywood Crossing', 'Salt Lake City', 'UT', '84130', '7');
insert into Shipping_Info (Name, Street, City, State, ZipCode, ShippingOptionID) values ('Office building', '6 Hauk Trail', 'Irvine', 'CA', '92710', '4');
insert into Shipping_Info (Name, Street, City, State, ZipCode, ShippingOptionID) values ('College dorm', '21 Rusk Trail', 'San Jose', 'CA', '95173', '5');
insert into Shipping_Info (Name, Street, City, State, ZipCode, ShippingOptionID) values ('Andrew''s apartment', '36537 Monument Alley', 'Richmond', 'VA', '23213', '7');
insert into Shipping_Info (Name, Street, City, State, ZipCode, ShippingOptionID) values ('Second house', '85180 Schurz Street', 'Saint Louis', 'MO', '63150', '2');
insert into Shipping_Info (Name, Street, City, State, ZipCode, ShippingOptionID) values ('Patel''s house', '02341 Jay Avenue', 'Dayton', 'OH', '45454', '6');
insert into Shipping_Info (Name, Street, City, State, ZipCode, ShippingOptionID) values ('Rea''s apartment', '77 Dapin Trail', 'Irving', 'TX', '75037', '1');
insert into Shipping_Info (Name, Street, City, State, ZipCode, ShippingOptionID) values ('Apartment building', '9 Kensington Crossing', 'Norfolk', 'VA', '23514', '3');
insert into Shipping_Info (Name, Street, City, State, ZipCode, ShippingOptionID) values ('Home', '57123 Mendota Point', 'Boston', 'MA', '02124', '2');
insert into Shipping_Info (Name, Street, City, State, ZipCode, ShippingOptionID) values ('Parent''s house', '78986 Talmadge Lane', 'Kansas City', 'MO', '64114', '3');
insert into Shipping_Info (Name, Street, City, State, ZipCode, ShippingOptionID) values ('Family''s house', '1 Carey Junction', 'Wichita', 'KS', '67230', '5');
insert into Shipping_Info (Name, Street, City, State, ZipCode, ShippingOptionID) values ('Home', '3094 Kropf Place', 'Memphis', 'TN', '38188', '7');
insert into Shipping_Info (Name, Street, City, State, ZipCode, ShippingOptionID) values ('Apartment', '4895 Miller Park', 'Greeley', 'CO', '80638', '4');
insert into Shipping_Info (Name, Street, City, State, ZipCode, ShippingOptionID) values ('Building mailroom', '932 Northwestern Court', 'Simi Valley', 'CA', '93094', '6');
insert into Shipping_Info (Name, Street, City, State, ZipCode, ShippingOptionID) values ('Rea''s home', '8547 Anzinger Drive', 'Denver', 'CO', '80255', '1');
insert into Shipping_Info (Name, Street, City, State, ZipCode, ShippingOptionID) values ('Dorm', '70 Grim Plaza', 'Tampa', 'FL', '33647', '6');
insert into Shipping_Info (Name, Street, City, State, ZipCode, ShippingOptionID) values ('Mailroom', '74 Anderson Drive', 'Richmond', 'VA', '23213', '1');
insert into Shipping_Info (Name, Street, City, State, ZipCode, ShippingOptionID) values ('College', '09039 Kinsman Trail', 'Montgomery', 'AL', '36104', '3');
insert into Shipping_Info (Name, Street, City, State, ZipCode, ShippingOptionID) values ('Second apartment', '5717 Aberg Park', 'Nashville', 'TN', '37235', '4');
insert into Shipping_Info (Name, Street, City, State, ZipCode, ShippingOptionID) values ('Justo''s house', '722 Onsgard Alley', 'Florence', 'SC', '29505', '2');
insert into Shipping_Info (Name, Street, City, State, ZipCode, ShippingOptionID) values ('Hebert''s', '8 Prairieview Center', 'Springfield', 'MO', '65898', '7');
insert into Shipping_Info (Name, Street, City, State, ZipCode, ShippingOptionID) values ('My house', '0 Gale Pass', 'Baltimore', 'MD', '21211', '5');
insert into Shipping_Info (Name, Street, City, State, ZipCode, ShippingOptionID) values ('Apartment 2', '2 Forest Run Junction', 'Pasadena', 'CA', '91109', '5');
insert into Shipping_Info (Name, Street, City, State, ZipCode, ShippingOptionID) values ('Jakie House', '9 Springs Circle', 'Philadelphia', 'PA', '19093', '3');
insert into Shipping_Info (Name, Street, City, State, ZipCode, ShippingOptionID) values ('Apartment Mail', '5579 Park Meadow Court', 'Albany', 'NY', '12237', '2');
insert into Shipping_Info (Name, Street, City, State, ZipCode, ShippingOptionID) values ('Office Building', '4 Buhler Crossing', 'Tampa', 'FL', '33615', '6');
insert into Shipping_Info (Name, Street, City, State, ZipCode, ShippingOptionID) values ('Izak''s House', '052 Bonner Plaza', 'Homestead', 'FL', '33034', '1');
insert into Shipping_Info (Name, Street, City, State, ZipCode, ShippingOptionID) values ('Mom''s House', '34261 Homewood Plaza', 'Columbus', 'OH', '43204', '7');
insert into Shipping_Info (Name, Street, City, State, ZipCode, ShippingOptionID) values ('Uni Dorm', '0 Summit Alley', 'Milwaukee', 'WI', '53205', '4');
insert into Shipping_Info (Name, Street, City, State, ZipCode, ShippingOptionID) values ('Uni', '127 Burrows Circle', 'El Paso', 'TX', '79916', '4');

/* Insert Shipping Info User */
insert into ShippingInfo_User (UserID, ShippingInfoId) values ('18', '2');
insert into ShippingInfo_User (UserID, ShippingInfoId) values ('12', '1');
insert into ShippingInfo_User (UserID, ShippingInfoId) values ('23', '5');
insert into ShippingInfo_User (UserID, ShippingInfoId) values ('13', '3');
insert into ShippingInfo_User (UserID, ShippingInfoId) values ('21', '7');
insert into ShippingInfo_User (UserID, ShippingInfoId) values ('24', '6');
insert into ShippingInfo_User (UserID, ShippingInfoId) values ('10', '4');
insert into ShippingInfo_User (UserID, ShippingInfoId) values ('28', '2');
insert into ShippingInfo_User (UserID, ShippingInfoId) values ('36', '7');
insert into ShippingInfo_User (UserID, ShippingInfoId) values ('40', '1');
insert into ShippingInfo_User (UserID, ShippingInfoId) values ('37', '3');
insert into ShippingInfo_User (UserID, ShippingInfoId) values ('22', '5');
insert into ShippingInfo_User (UserID, ShippingInfoId) values ('7', '4');
insert into ShippingInfo_User (UserID, ShippingInfoId) values ('2', '6');
insert into ShippingInfo_User (UserID, ShippingInfoId) values ('8', '1');
insert into ShippingInfo_User (UserID, ShippingInfoId) values ('27', '5');
insert into ShippingInfo_User (UserID, ShippingInfoId) values ('33', '6');
insert into ShippingInfo_User (UserID, ShippingInfoId) values ('29', '7');
insert into ShippingInfo_User (UserID, ShippingInfoId) values ('1', '2');
insert into ShippingInfo_User (UserID, ShippingInfoId) values ('11', '4');
insert into ShippingInfo_User (UserID, ShippingInfoId) values ('14', '3');
insert into ShippingInfo_User (UserID, ShippingInfoId) values ('38', '6');
insert into ShippingInfo_User (UserID, ShippingInfoId) values ('26', '3');
insert into ShippingInfo_User (UserID, ShippingInfoId) values ('35', '4');
insert into ShippingInfo_User (UserID, ShippingInfoId) values ('39', '2');
insert into ShippingInfo_User (UserID, ShippingInfoId) values ('6', '1');
insert into ShippingInfo_User (UserID, ShippingInfoId) values ('16', '7');
insert into ShippingInfo_User (UserID, ShippingInfoId) values ('15', '5');
insert into ShippingInfo_User (UserID, ShippingInfoId) values ('25', '7');
insert into ShippingInfo_User (UserID, ShippingInfoId) values ('34', '1');
insert into ShippingInfo_User (UserID, ShippingInfoId) values ('30', '3');
insert into ShippingInfo_User (UserID, ShippingInfoId) values ('20', '2');
insert into ShippingInfo_User (UserID, ShippingInfoId) values ('19', '6');
insert into ShippingInfo_User (UserID, ShippingInfoId) values ('9', '5');
insert into ShippingInfo_User (UserID, ShippingInfoId) values ('31', '4');
insert into ShippingInfo_User (UserID, ShippingInfoId) values ('5', '1');
insert into ShippingInfo_User (UserID, ShippingInfoId) values ('17', '6');
insert into ShippingInfo_User (UserID, ShippingInfoId) values ('32', '5');
insert into ShippingInfo_User (UserID, ShippingInfoId) values ('4', '3');
insert into ShippingInfo_User (UserID, ShippingInfoId) values ('3', '7');
insert into ShippingInfo_User (UserID, ShippingInfoId) values ('5', '2');
insert into ShippingInfo_User (UserID, ShippingInfoId) values ('40', '4');
insert into ShippingInfo_User (UserID, ShippingInfoId) values ('12', '6');
insert into ShippingInfo_User (UserID, ShippingInfoId) values ('27', '2');
insert into ShippingInfo_User (UserID, ShippingInfoId) values ('32', '3');
insert into ShippingInfo_User (UserID, ShippingInfoId) values ('26', '1');
insert into ShippingInfo_User (UserID, ShippingInfoId) values ('19', '5');
insert into ShippingInfo_User (UserID, ShippingInfoId) values ('37', '4');
insert into ShippingInfo_User (UserID, ShippingInfoId) values ('10', '7');
insert into ShippingInfo_User (UserID, ShippingInfoId) values ('11', '5');

/* Insert Notifications */
insert into Notifications (SubjectLine, Messages, TimeStamp) values ('Flash Sale Alert!', 'Grab your favorites before they are gone', '2023-06-06 03:30:44');
insert into Notifications (SubjectLine, Messages, TimeStamp) values ('New Arrivals', 'Take a look at our new fashion finds!', '2023-09-15 17:52:58');
insert into Notifications (SubjectLine, Messages, TimeStamp) values ('Half Price Alert', 'All items are 50% off!!!', '2023-03-09 04:43:41');
insert into Notifications (SubjectLine, Messages, TimeStamp) values ('Your Wishlist items are on sale!', 'Check out your wishlist now!', '2023-02-21 05:01:13');
insert into Notifications (SubjectLine, Messages, TimeStamp) values ('$8 Off All Tops', 'Check out your favorite tops!', '2023-06-02 23:58:48');
insert into Notifications (SubjectLine, Messages, TimeStamp) values ('Alert! 20% Off', 'Your favorite items are now 20% off', '2023-05-01 15:11:31');
insert into Notifications (SubjectLine, Messages, TimeStamp) values ('Limited Offer Today', '$10 off all orders above $50', '2023-01-11 11:15:01');
insert into Notifications (SubjectLine, Messages, TimeStamp) values ('BLACK FRIDAY DEALS', 'Biggest sale of the year is here!', '2023-11-24 11:24:10');
insert into Notifications (SubjectLine, Messages, TimeStamp) values ('Winter Blowout', '25% off outerwear, wool, and knit tops', '2023-11-03 03:42:44');
insert into Notifications (SubjectLine, Messages, TimeStamp) values ('Spring Sale Is Here!', 'Your favorite tops are 25% off now', '2023-08-15 10:44:37');
insert into Notifications (SubjectLine, Messages, TimeStamp) values ('Weekend Flash Sale', 'Check out amazing outfits at 50% off', '2023-04-18 04:47:19');
insert into Notifications (SubjectLine, Messages, TimeStamp) values ('Newly Curated Outfits!', 'You will definitely love these outfits', '2023-01-05 13:25:24');
insert into Notifications (SubjectLine, Messages, TimeStamp) values ('CYBER MONDAY', 'Miss out Black Friday deals? - 50% off everything today! ', '2023-11-27 02:56:19');
insert into Notifications (SubjectLine, Messages, TimeStamp) values ('Clearance Discounts Only Today', 'Selected items at 80% discount', '2023-05-16 15:44:54');
insert into Notifications (SubjectLine, Messages, TimeStamp) values ('Amazing Deals', 'Selected items up to 70% off', '2022-12-31 22:04:15');
insert into Notifications (SubjectLine, Messages, TimeStamp) values ('Hurry! Limited Deals', '$7 off all trendy bags', '2023-08-11 22:22:56');
insert into Notifications (SubjectLine, Messages, TimeStamp) values ('New items from your favorite brands', 'Your favorite brands just dropped new styles', '2023-05-01 01:16:32');
insert into Notifications (SubjectLine, Messages, TimeStamp) values ('Add your wishlist to the cart now!', '$5 off everything only today', '2023-07-19 19:38:30');
insert into Notifications (SubjectLine, Messages, TimeStamp) values ('Your Order is Ready!', 'Your order is ready to be shipped to you, we will keep you updated!', '2023-10-03 00:23:28');
insert into Notifications (SubjectLine, Messages, TimeStamp) values ('Personalized Picks', 'Check out new outfits we have curated for YOU!', '2023-05-03 15:04:31');
insert into Notifications (SubjectLine, Messages, TimeStamp) values ('Your Order is on the way', 'Your Order will arrive soon! Look out for our notifications', '2023-10-24 15:06:43');
insert into Notifications (SubjectLine, Messages, TimeStamp) values ('Last piece - check out now!', 'Your favorite items are running out', '2023-01-13 15:34:59');
insert into Notifications (SubjectLine, Messages, TimeStamp) values ('Your Order has arrived!', 'Your order has been delivered - Let us know your feedback!', '2023-02-04 17:16:23');
insert into Notifications (SubjectLine, Messages, TimeStamp) values ('We hope you enjoy your order!', 'Let us know your experience', '2023-03-13 11:52:51');
insert into Notifications (SubjectLine, Messages, TimeStamp) values ('Trend Alert!', 'Trendy collection has just arrived', '2023-07-13 04:25:01');
insert into Notifications (SubjectLine, Messages, TimeStamp) values ('Upgrade Your Wardrobe', 'Personalized outfits to enhance your everyday styles!', '2023-01-24 20:21:32');
insert into Notifications (SubjectLine, Messages, TimeStamp) values ('Sneak Peek at the New Collection', 'Check out the new collection from our beloved brands', '2022-12-21 02:26:32');
insert into Notifications (SubjectLine, Messages, TimeStamp) values ('Thank you for shopping with us!', 'We hope you have an amazing experience. We will keep you updated on your order!', '2023-01-26 08:41:45');
insert into Notifications (SubjectLine, Messages, TimeStamp) values ('Ready for Summer Discount?', 'Add new items to your summer collection', '2023-05-22 23:21:32');
insert into Notifications (SubjectLine, Messages, TimeStamp) values ('24H Sale!', '40% off all styles only today', '2023-10-25 23:47:41');

/* Insert User_Notif */
insert into User_Notif (UserID, NotificationID) values ('17', '3');
insert into User_Notif (UserID, NotificationID) values ('28', '12');
insert into User_Notif (UserID, NotificationID) values ('40', '24');
insert into User_Notif (UserID, NotificationID) values ('30', '7');
insert into User_Notif (UserID, NotificationID) values ('13', '19');
insert into User_Notif (UserID, NotificationID) values ('27', '9');
insert into User_Notif (UserID, NotificationID) values ('16', '2');
insert into User_Notif (UserID, NotificationID) values ('38', '11');
insert into User_Notif (UserID, NotificationID) values ('32', '30');
insert into User_Notif (UserID, NotificationID) values ('34', '29');
insert into User_Notif (UserID, NotificationID) values ('7', '8');
insert into User_Notif (UserID, NotificationID) values ('37', '25');
insert into User_Notif (UserID, NotificationID) values ('20', '16');
insert into User_Notif (UserID, NotificationID) values ('22', '22');
insert into User_Notif (UserID, NotificationID) values ('19', '13');
insert into User_Notif (UserID, NotificationID) values ('23', '15');
insert into User_Notif (UserID, NotificationID) values ('29', '4');
insert into User_Notif (UserID, NotificationID) values ('15', '17');
insert into User_Notif (UserID, NotificationID) values ('10', '1');
insert into User_Notif (UserID, NotificationID) values ('26', '10');
insert into User_Notif (UserID, NotificationID) values ('33', '26');
insert into User_Notif (UserID, NotificationID) values ('24', '6');
insert into User_Notif (UserID, NotificationID) values ('39', '21');
insert into User_Notif (UserID, NotificationID) values ('35', '20');
insert into User_Notif (UserID, NotificationID) values ('25', '23');
insert into User_Notif (UserID, NotificationID) values ('31', '14');
insert into User_Notif (UserID, NotificationID) values ('1', '27');
insert into User_Notif (UserID, NotificationID) values ('18', '18');
insert into User_Notif (UserID, NotificationID) values ('8', '28');
insert into User_Notif (UserID, NotificationID) values ('6', '5');
insert into User_Notif (UserID, NotificationID) values ('36', '25');
insert into User_Notif (UserID, NotificationID) values ('4', '30');
insert into User_Notif (UserID, NotificationID) values ('2', '11');
insert into User_Notif (UserID, NotificationID) values ('12', '8');
insert into User_Notif (UserID, NotificationID) values ('11', '28');
insert into User_Notif (UserID, NotificationID) values ('5', '19');
insert into User_Notif (UserID, NotificationID) values ('21', '17');
insert into User_Notif (UserID, NotificationID) values ('14', '15');
insert into User_Notif (UserID, NotificationID) values ('9', '9');
insert into User_Notif (UserID, NotificationID) values ('3', '16');
insert into User_Notif (UserID, NotificationID) values ('6', '2');
insert into User_Notif (UserID, NotificationID) values ('2', '12');
insert into User_Notif (UserID, NotificationID) values ('32', '27');
insert into User_Notif (UserID, NotificationID) values ('35', '2');
insert into User_Notif (UserID, NotificationID) values ('30', '10');
insert into User_Notif (UserID, NotificationID) values ('36', '3');
insert into User_Notif (UserID, NotificationID) values ('17', '24');
insert into User_Notif (UserID, NotificationID) values ('28', '26');
insert into User_Notif (UserID, NotificationID) values ('18', '4');
insert into User_Notif (UserID, NotificationID) values ('26', '14');

/* Insert Wishlist */
insert into Wishlist (Name, UserID) values ('Amanda''s Wishlist', '1');
insert into Wishlist (Name, UserID) values ('Wishlist', '2');
insert into Wishlist (Name, UserID) values ('Celine''s Fav', '3');
insert into Wishlist (Name, UserID) values ('My Favorites', '4');
insert into Wishlist (Name, UserID) values ('My wishlist', '5');
insert into Wishlist (Name, UserID) values ('Wants', '6');
insert into Wishlist (Name, UserID) values ('To buy', '7');
insert into Wishlist (Name, UserID) values ('Favs', '8');
insert into Wishlist (Name, UserID) values ('My favs', '9');
insert into Wishlist (Name, UserID) values ('Christmas Wishlist', '10');
insert into Wishlist (Name, UserID) values ('Dan''s Fav', '11');
insert into Wishlist (Name, UserID) values ('Wish', '12');
insert into Wishlist (Name, UserID) values ('My wishlist', '13');
insert into Wishlist (Name, UserID) values ('Favorites', '14');
insert into Wishlist (Name, UserID) values ('Outfits I want', '15');
insert into Wishlist (Name, UserID) values ('Doris Wishlist', '16');
insert into Wishlist (Name, UserID) values ('Wishlist', '17');
insert into Wishlist (Name, UserID) values ('Newyear wishlist', '18');
insert into Wishlist (Name, UserID) values ('Buy for Christmas', '19');
insert into Wishlist (Name, UserID) values ('Outfit planner', '20');
insert into Wishlist (Name, UserID) values ('My favorite', '21');
insert into Wishlist (Name, UserID) values ('Holiday Wishlist', '22');
insert into Wishlist (Name, UserID) values ('Favorites', '23');
insert into Wishlist (Name, UserID) values ('Gar''s Wishlist', '24');
insert into Wishlist (Name, UserID) values ('Things I want', '25');
insert into Wishlist (Name, UserID) values ('Christmas present', '26');
insert into Wishlist (Name, UserID) values ('Newyear wants', '27');
insert into Wishlist (Name, UserID) values ('My favorite outfits', '28');
insert into Wishlist (Name, UserID) values ('My favorite items', '29');
insert into Wishlist (Name, UserID) values ('Wishlist', '30');
insert into Wishlist (Name, UserID) values ('Chance''s Wishlist', '31');
insert into Wishlist (Name, UserID) values ('Outfits I want', '32');
insert into Wishlist (Name, UserID) values ('Holiday gifts', '33');
insert into Wishlist (Name, UserID) values ('Favs', '34');
insert into Wishlist (Name, UserID) values ('My Wishlist', '35');
insert into Wishlist (Name, UserID) values ('To buy', '36');
insert into Wishlist (Name, UserID) values ('Outfits for work', '37');
insert into Wishlist (Name, UserID) values ('Outfits for holiday', '38');
insert into Wishlist (Name, UserID) values ('Wishlist', '39');
insert into Wishlist (Name, UserID) values ('Favorites', '40');

/* Insert Categories */
insert into Category (Material, CategoryName) values ('Cotton', 'Tops');
insert into Category (Material, CategoryName) values ('Denim', 'Bottoms');
insert into Category (Material, CategoryName) values ('Denim', 'Outerwear');
insert into Category (Material, CategoryName) values ('Cotton', 'Dresses');
insert into Category (Material, CategoryName) values ('Leather', 'Outerwear');
insert into Category (Material, CategoryName) values ('Leather', 'Bags');
insert into Category (Material, CategoryName) values ('Wool', 'Tops');
insert into Category (Material, CategoryName) values ('Wool', 'Outerwear');
insert into Category (Material, CategoryName) values ('Linen', 'Tops');
insert into Category (Material, CategoryName) values ('Linen', 'Bottoms');
insert into Category (Material, CategoryName) values ('Polyester', 'Tops');
insert into Category (Material, CategoryName) values ('Nylon', 'Tops');
insert into Category (Material, CategoryName) values ('Velvet', 'Dresses');
insert into Category (Material, CategoryName) values ('Velvet', 'Outerwear');
insert into Category (Material, CategoryName) values ('Silk', 'Tops');
insert into Category (Material, CategoryName) values ('Silk', 'Bottoms');
insert into Category (Material, CategoryName) values ('Fur', 'Outerwear');
insert into Category (Material, CategoryName) values ('Nylon', 'Outerwear');
insert into Category (Material, CategoryName) values ('Denim', 'Bags');
insert into Category (Material, CategoryName) values ('Knit', 'Tops');

/* Insert Brands */
insert into Brand (Name, Rating, Type) values ('Anthropologie', 8, 'Unique, full-lifestyle shopping');
insert into Brand (Name, Rating, Type) values ('Alo Yoga', 9, 'Technologically advanced yoga clothing');
insert into Brand (Name, Rating, Type) values ('Ami Paris', 10, 'Contemporary and authentic fashion');
insert into Brand (Name, Rating, Type) values ('Aritzia', 10, 'Everyday luxury');
insert into Brand (Name, Rating, Type) values ('Banana Republic', 9, 'Chic and modern casualwear');
insert into Brand (Name, Rating, Type) values ('Brandy Melville', 7, 'Trendy comfortable clothing');
insert into Brand (Name, Rating, Type) values ('Burberry', 10, 'British high end fashion house');
insert into Brand (Name, Rating, Type) values ('Calvin Klein', 8, 'Simple, comfortable, but stylish clothes');
insert into Brand (Name, Rating, Type) values ('Carhartt', 8, 'Classic clothing with high durability');
insert into Brand (Name, Rating, Type) values ('Champion', 7, 'Classic sportswear');
insert into Brand (Name, Rating, Type) values ('Coach', 8, 'Authentic fashion house founded in New York');
insert into Brand (Name, Rating, Type) values ('Comme des Garcons', 9, 'Unique, iconic fashion house founded in Japan');
insert into Brand (Name, Rating, Type) values ('COS', 8, 'Ready-to-wear with high focus on craftmanship and sustainability');
insert into Brand (Name, Rating, Type) values ('Diesel', 9, 'Global leader in denim fashion');
insert into Brand (Name, Rating, Type) values ('Everlane', 7, 'Modern basics');
insert into Brand (Name, Rating, Type) values ('Forever 21', 5, 'Fashion basics');
insert into Brand (Name, Rating, Type) values ('H&M', 5, 'Customer-focused essential apparel');
insert into Brand (Name, Rating, Type) values ('Kate Spade', 7, 'Independent and playful fashion brand from New York');
insert into Brand (Name, Rating, Type) values ('Levi', 8, 'Authentic jeanswear');
insert into Brand (Name, Rating, Type) values ('Madewell', 7, 'Staple fashion for everyone');
insert into Brand (Name, Rating, Type) values ('Maison Kitsune', 10, 'French-Japanese lifestyle brand');
insert into Brand (Name, Rating, Type) values ('Massimo Dutti', 8, 'Design with exclusive materials and fabrics');
insert into Brand (Name, Rating, Type) values ('Max Mara', 10, 'High end classic ready-to-wear');
insert into Brand (Name, Rating, Type) values ('Nike', 8, 'Worlds largest athletic apparel');
insert into Brand (Name, Rating, Type) values ('Oak + Fort', 7, 'Modern, trendy lifestyle brand');
insert into Brand (Name, Rating, Type) values ('Old Navy', 6, 'Must-have fashion essentials');
insert into Brand (Name, Rating, Type) values ('PacSun', 6, 'Youth-inspired apparel');
insert into Brand (Name, Rating, Type) values ('Patagonia', 10, 'Environmentally sustainable outdoor clothing');
insert into Brand (Name, Rating, Type) values ('Polo Ralph Lauren', 10, 'Classic luxury lifestyle');
insert into Brand (Name, Rating, Type) values ('Prada', 10, 'Italian unique luxury fashion house');
insert into Brand (Name, Rating, Type) values ('Rag&Bone', 9, 'Classic yet modern ready-to-wear');
insert into Brand (Name, Rating, Type) values ('Reformation', 8, 'Sustainable, trendy clothing');
insert into Brand (Name, Rating, Type) values ('Saint Laurent', 10, 'Paris leading fashion house');
insert into Brand (Name, Rating, Type) values ('Stussy', 9, 'Unique skate/streetwear brand');
insert into Brand (Name, Rating, Type) values ('The North Face', 9, 'Advanced outdoor products for everyone');
insert into Brand (Name, Rating, Type) values ('Theory', 7, 'Contemporary fashion label');
insert into Brand (Name, Rating, Type) values ('Tommy Hilfiger', 8, 'Premium style and quality');
insert into Brand (Name, Rating, Type) values ('Uniqlo', 8, 'Minimalistic global clothing brand');
insert into Brand (Name, Rating, Type) values ('Urban Outfitters', 7, 'Experiential fashion retail with a wide variety of styles');
insert into Brand (Name, Rating, Type) values ('Zara', 6, 'Simple, chic clothing');

/* Insert Styles */
insert into Style (Color, AestheticName, TrendRating) values ('Teal', 'Vintage', 7);
insert into Style (Color, AestheticName, TrendRating) values ('Blue', 'Gorpcore', 6);
insert into Style (Color, AestheticName, TrendRating) values ('Black', 'Quiet Luxury', 9);
insert into Style (Color, AestheticName, TrendRating) values ('Pink', 'Cottagecore', 4);
insert into Style (Color, AestheticName, TrendRating) values ('Red', 'Vintage', 6);
insert into Style (Color, AestheticName, TrendRating) values ('Beige', 'Vintage', 6);
insert into Style (Color, AestheticName, TrendRating) values ('Brown', 'Grunge', 6);
insert into Style (Color, AestheticName, TrendRating) values ('Crimson', 'Academia', 4);
insert into Style (Color, AestheticName, TrendRating) values ('Sage', 'Cottagecore', 4);
insert into Style (Color, AestheticName, TrendRating) values ('Violet', 'Coquette', 7);
insert into Style (Color, AestheticName, TrendRating) values ('Blue', 'Y2K', 4);
insert into Style (Color, AestheticName, TrendRating) values ('Black', 'Streetwear', 5);
insert into Style (Color, AestheticName, TrendRating) values ('Khaki', 'Quiet Luxury', 9);
insert into Style (Color, AestheticName, TrendRating) values ('Yellow', 'Vintage', 7);
insert into Style (Color, AestheticName, TrendRating) values ('Grey', 'Clean', 7);
insert into Style (Color, AestheticName, TrendRating) values ('Blue', 'Streetwear', 5);
insert into Style (Color, AestheticName, TrendRating) values ('Black', 'Grunge', 6);
insert into Style (Color, AestheticName, TrendRating) values ('Goldenrod', 'Quiet Luxury', 9);
insert into Style (Color, AestheticName, TrendRating) values ('Moss', 'Grunge', 6);
insert into Style (Color, AestheticName, TrendRating) values ('Lime', 'Y2K', 4);
insert into Style (Color, AestheticName, TrendRating) values ('Maroon', 'Quiet Luxury', 9);
insert into Style (Color, AestheticName, TrendRating) values ('Beige', 'Clean', 8);
insert into Style (Color, AestheticName, TrendRating) values ('Black', 'Gorpcore', 6);
insert into Style (Color, AestheticName, TrendRating) values ('Grey', 'Gorpcore', 6);
insert into Style (Color, AestheticName, TrendRating) values ('White', 'Quiet Luxury', 9);
insert into Style (Color, AestheticName, TrendRating) values ('White', 'Academia', 4);
insert into Style (Color, AestheticName, TrendRating) values ('Brown', 'Clean', 8);
insert into Style (Color, AestheticName, TrendRating) values ('White', 'Streetwear', 5);
insert into Style (Color, AestheticName, TrendRating) values ('Blush', 'Coquette', 7);
insert into Style (Color, AestheticName, TrendRating) values ('Red', 'Clean', 8);

/* Insert Discounts */
insert into Discount (Name, Amount, Description) values ('10% Off', 10, '10% off all items');
insert into Discount (Name, Amount, Description) values ('Flash Sale', 50, 'Take 50% off all items');
insert into Discount (Name, Amount, Description) values ('Black Friday Deals', 70, 'Up to 70% off all items');
insert into Discount (Name, Amount, Description) values ('$8 Off Tops', 8, '$8 off all tops');
insert into Discount (Name, Amount, Description) values ('$10 Off Outerwear', 10, '$10 off all outerwear');
insert into Discount (Name, Amount, Description) values ('Clearance Discounts', 80, 'Up to 80% off clearance items');
insert into Discount (Name, Amount, Description) values ('Cyber Monday Sale', 50, '50% off all items');
insert into Discount (Name, Amount, Description) values ('$7 Off Bags', 7, '$7 off all bags');
insert into Discount (Name, Amount, Description) values ('24-Hour Sale', 40, '40% off all items in 24-hour');
insert into Discount (Name, Amount, Description) values ('Winter Blowout', 25, '25% off outerwear, and knit and wool tops');
insert into Discount (Name, Amount, Description) values ('Spring Sale', 20, '20% off all tops');
insert into Discount (Name, Amount, Description) values ('25% Off Dresses', 25, '25% off all dresses');
insert into Discount (Name, Amount, Description) values ('$5 Off', 5, '$5 off all orders');
insert into Discount (Name, Amount, Description) values ('20% Off', 20, '20% off all items');
insert into Discount (Name, Amount, Description) values ('Final Sale', 70, '70% off last chance pieces');
insert into Discount (Name, Amount, Description) values ('Limited Offer', 10, '$10 off for orders above $50');
insert into Discount (Name, Amount, Description) values ('Summer Sale', 15, '15% off cotton tops and bottoms');
insert into Discount (Name, Amount, Description) values ('Back To School Discounts', 10, '10% off all tops, bottoms, and dresses');
insert into Discount (Name, Amount, Description) values ('Early Sale', 10, '10% off all tops');
insert into Discount (Name, Amount, Description) values ('End of Year Sale', 20, '20% off all items');

/* Insert Outfits */
INSERT INTO Outfit (Style, BodyFit, Price, CostRating, Name, UserID) VALUES ('Vintage', 'Classic Fit', 128.41, '$$', 'Vintage Winter Outfit', '21');
INSERT INTO Outfit (Style, BodyFit, Price, CostRating, Name, UserID) VALUES ('Gorpcore', 'Slim Fit', 616.35, '$$$', 'WaterProof Fit', '16');
INSERT INTO Outfit (Style, BodyFit, Price, CostRating, Name, UserID) VALUES ('Clean', 'Classic Fit', 92.55, '$', 'Back to School Essential', '36');
INSERT INTO Outfit (Style, BodyFit, Price, CostRating, Name, UserID) VALUES ('Clean', 'Classic Fit', 32.32, '$', 'Office Essential', '11');
INSERT INTO Outfit (Style, BodyFit, Price, CostRating, Name, UserID) VALUES ('Vintage', 'Slim Fit', 134.72, '$$', 'Vintage Party', '6');
INSERT INTO Outfit (Style, BodyFit, Price, CostRating, Name, UserID) VALUES ('Cottagecore', 'Classic Fit', 60.54, '$', 'Nature', '38');
INSERT INTO Outfit (Style, BodyFit, Price, CostRating, Name, UserID) VALUES ('Academia', 'Classic Fit', 88.70, '$', 'Dark Academia Winter Outfit', '8');
INSERT INTO Outfit (Style, BodyFit, Price, CostRating, Name, UserID) VALUES ('Academia', 'Classic Fit', 75.19, '$', 'Classic', '9');
INSERT INTO Outfit (Style, BodyFit, Price, CostRating, Name, UserID) VALUES ('Streetwear', 'Oversized Fit', 147.66, '$$', 'Comfy Cool Fit', '32');
INSERT INTO Outfit (Style, BodyFit, Price, CostRating, Name, UserID) VALUES ('Streetwear', 'Oversized Fit', 97.87, '$', 'Streetwear Fit', '25');
INSERT INTO Outfit (Style, BodyFit, Price, CostRating, Name, UserID) VALUES ('Streetwear', 'Slim Fit', 323.79, '$$$', 'Cool Outfit', '24');
INSERT INTO Outfit (Style, BodyFit, Price, CostRating, Name, UserID) VALUES ('Quiet Luxury', 'Slim Fit', 320.51, '$$$', 'Minimalistic Outift', '29');
INSERT INTO Outfit (Style, BodyFit, Price, CostRating, Name, UserID) VALUES ('Clean', 'Slim Fit', 858.6, '$$$', 'Clean Girl Oufit', '26');
INSERT INTO Outfit (Style, BodyFit, Price, CostRating, Name, UserID) VALUES ('Cottagecore', 'Slim Fit', 131.71, '$$', 'Cottage', '27');
INSERT INTO Outfit (Style, BodyFit, Price, CostRating, Name, UserID) VALUES ('Y2K', 'Slim Fit', 171.61, '$$', 'Colorful Y2K Fit', '14');
INSERT INTO Outfit (Style, BodyFit, Price, CostRating, Name, UserID) VALUES ('Gorpcore', 'Oversized Fit', 413.67, '$$$', 'AllBlack Outfit', '10');
INSERT INTO Outfit (Style, BodyFit, Price, CostRating, Name, UserID) VALUES ('Streetwear', 'Classic Fit', 86.61, '$', 'Streetwear Full Outfit', '34');
INSERT INTO Outfit (Style, BodyFit, Price, CostRating, Name, UserID) VALUES ('Quiet Luxury', 'Classic Fit', 74.47, '$', 'Elegance', '40');
INSERT INTO Outfit (Style, BodyFit, Price, CostRating, Name, UserID) VALUES ('Quiet Luxury', 'Classic Fit', 98.28, '$', 'Everyday Elegance', '35');
INSERT INTO Outfit (Style, BodyFit, Price, CostRating, Name, UserID) VALUES ('Clean', 'Classic Fit', 56.73, '$', 'Everyday Casual', '39');
INSERT INTO Outfit (Style, BodyFit, Price, CostRating, Name, UserID) VALUES ('Y2K', 'Slim Fit', 258.93, '$$$', 'Y2K Unique Outfit', '31');
INSERT INTO Outfit (Style, BodyFit, Price, CostRating, Name, UserID) VALUES ('Cottagecore', 'Classic Fit', 103.4, '$$', 'Cottagecore Unique Outfit', '22');
INSERT INTO Outfit (Style, BodyFit, Price, CostRating, Name, UserID) VALUES ('Coquette', 'Slim Fit', 414.1, '$$$', 'Soft Pink Outfit', '4');
INSERT INTO Outfit (Style, BodyFit, Price, CostRating, Name, UserID) VALUES ('Cottagecore', 'Slim Fit', 48.28, '$', 'Cottagecore', '13');
INSERT INTO Outfit (Style, BodyFit, Price, CostRating, Name, UserID) VALUES ('Academia', 'Classic Fit', 117.72, '$$', 'Formal Outfit', '17');
INSERT INTO Outfit (Style, BodyFit, Price, CostRating, Name, UserID) VALUES ('Clean', 'Oversized Fit', 190.5, '$$$', 'Miimalistic Formal', '23');
INSERT INTO Outfit (Style, BodyFit, Price, CostRating, Name, UserID) VALUES ('Gorpcore', 'Oversized Fit', 403.65, '$$$', 'Futuristic', '12');
INSERT INTO Outfit (Style, BodyFit, Price, CostRating, Name, UserID) VALUES ('Streetwear', 'Oversized Fit', 804.07, '$$$', 'Simple Streetwear', '33');
INSERT INTO Outfit (Style, BodyFit, Price, CostRating, Name, UserID) VALUES ('Vintage', 'Oversized Fit', 322.28, '$$$', '80s Vintage', '28');
INSERT INTO Outfit (Style, BodyFit, Price, CostRating, Name, UserID) VALUES ('Grunge', 'Oversized Fit', 157.78, '$$', 'Grey-Black Grunge Fit', '20');
INSERT INTO Outfit (Style, BodyFit, Price, CostRating, Name, UserID) VALUES ('Quiet Luxury', 'Slim Fit', 55.28, '$', 'Best Outfit for Work', '15');
INSERT INTO Outfit (Style, BodyFit, Price, CostRating, Name, UserID) VALUES ('Clean', 'Classic Fit', 74.95, '$', 'Easy Style', '1');
INSERT INTO Outfit (Style, BodyFit, Price, CostRating, Name, UserID) VALUES ('Coquette', 'Slim Fit', 86.53, '$', 'Comfy Girl Fit', '2');
INSERT INTO Outfit (Style, BodyFit, Price, CostRating, Name, UserID) VALUES ('Y2K', 'Slim Fit', 62.69, '$', 'Unique 2000s Outfit', '37');
INSERT INTO Outfit (Style, BodyFit, Price, CostRating, Name, UserID) VALUES ('Vintage', 'Classic Fit', 36.48, '$', 'Classic Vintage', '19');
INSERT INTO Outfit (Style, BodyFit, Price, CostRating, Name, UserID) VALUES ('Clean', 'Classic Fit', 141.13, '$$', 'Simple Clean Outfit', '30');
INSERT INTO Outfit (Style, BodyFit, Price, CostRating, Name, UserID) VALUES ('Quiet Luxury', 'Slim Fit', 507.55, '$$$', 'Quiet Luxury Full Outfit', '18');
INSERT INTO Outfit (Style, BodyFit, Price, CostRating, Name, UserID) VALUES ('Streetwear', 'Oversized Fit', 763.87, '$$$', 'Streetwear Unqiue Outfit', '5');
INSERT INTO Outfit (Style, BodyFit, Price, CostRating, Name, UserID) VALUES ('Gorpcore', 'Classic Fit', 79.28, '$', 'Gorpcore Unique Outfit', '3');
INSERT INTO Outfit (Style, BodyFit, Price, CostRating, Name, UserID) VALUES ('Y2K', 'Classic Fit', 74.2, '$', 'Y2K Style', '7');
INSERT INTO Outfit (Style, BodyFit, Price, CostRating, Name, UserID) VALUES ('Vintage', 'Oversized Fit', 304.52, '$$$', 'Retro Outfit', '33');
INSERT INTO Outfit (Style, BodyFit, Price, CostRating, Name, UserID) VALUES ('Clean', 'Slim Fit', 776.4, '$$$', 'Essential', '27');
INSERT INTO Outfit (Style, BodyFit, Price, CostRating, Name, UserID) VALUES ('Quiet Luxury', 'Slim Fit', 576.35, '$$$', 'Simple Luxury', '10');
INSERT INTO Outfit (Style, BodyFit, Price, CostRating, Name, UserID) VALUES ('Gorpcore', 'Oversized Fit', 841.64, '$$$', 'Gorpcore Essential', '16');
INSERT INTO Outfit (Style, BodyFit, Price, CostRating, Name, UserID) VALUES ('Cottagecore', 'Oversized Fit', 194.41, '$$$', 'Cottagecore Essential', '26');
INSERT INTO Outfit (Style, BodyFit, Price, CostRating, Name, UserID) VALUES ('Grunge', 'Slim Fit', 225.42, '$$$', 'Grunge Outfit', '24');
INSERT INTO Outfit (Style, BodyFit, Price, CostRating, Name, UserID) VALUES ('Clean', 'Slim Fit', 567.95, '$$$', 'Winter Simple Outfit', '38');
INSERT INTO Outfit (Style, BodyFit, Price, CostRating, Name, UserID) VALUES ('Academia', 'Classic Fit', 174.42, '$$', 'Elegant Formal', '30');
INSERT INTO Outfit (Style, BodyFit, Price, CostRating, Name, UserID) VALUES ('Grunge', 'Oversized Fit', 108.34, '$$', 'Oversized Grunge Outfit', '36');
INSERT INTO Outfit (Style, BodyFit, Price, CostRating, Name, UserID) VALUES ('Clean', 'Classic Fit', 52.22, '$', 'School Essential', '39');

/* Insert Clothing Items */
insert into Clothing_Item (Size, Name, Description, Price, DiscountID, CategoryID, CartID, BrandName, StyleID) values ('S', 'Shoulder bag', '', 139.40, '15', '6', '22', 'Coach', '20');
insert into Clothing_Item (Size, Name, Description, Price, DiscountID, CategoryID, CartID, BrandName, StyleID) values ('XS', 'Turtleneck Sweater', '', 96.14, '6', '20', '16', 'Aritzia', '18');
insert into Clothing_Item (Size, Name, Description, Price, DiscountID, CategoryID, CartID, BrandName, StyleID) values ('3XL', 'Simple T-Shirt', 'Lorem Ipsum', 48.00, '19', '11', '14', 'Anthropologie', '7');
insert into Clothing_Item (Size, Name, Description, Price, DiscountID, CategoryID, CartID, BrandName, StyleID) values ('2XL', 'Party Dress', 'In est risus, auctor sed, tristique in, tempus sit amet, sem. Fusce consequat.', 55.62, '12', '13', '36', 'Everlane', '26');
insert into Clothing_Item (Size, Name, Description, Price, DiscountID, CategoryID, CartID, BrandName, StyleID) values ('L', 'Denim Tote', '', 62.93, '13', '19', '6', 'H&M', '1');
insert into Clothing_Item (Size, Name, Description, Price, DiscountID, CategoryID, CartID, BrandName, StyleID) values ('L', 'Oversized Top', 'Ut at dolor quis odio consequat varius.', 59.00, '1', '12', '37', 'Uniqlo', '14');
insert into Clothing_Item (Size, Name, Description, Price, DiscountID, CategoryID, CartID, BrandName, StyleID) values ('M', 'Silk Long Skirt', 'Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu.', 18.89, '10', '16', '9', 'Brandy Melville', '3');
insert into Clothing_Item (Size, Name, Description, Price, DiscountID, CategoryID, CartID, BrandName, StyleID) values ('XL', 'Spring Dress', 'Praesent lectus.', 3.7, '20', '4', '25', 'Urban Outfitters', '5');
insert into Clothing_Item (Size, Name, Description, Price, DiscountID, CategoryID, CartID, BrandName, StyleID) values ('XS', 'Faux Fur Coat', '', 60.82, '8', '17', '5', 'Urban Outfitters', '12');
insert into Clothing_Item (Size, Name, Description, Price, DiscountID, CategoryID, CartID, BrandName, StyleID) values ('L', 'Winter Cardigan', '', 93.60, '9', '8', '31', 'Ami Paris', '25');
insert into Clothing_Item (Size, Name, Description, Price, DiscountID, CategoryID, CartID, BrandName, StyleID) values ('L', 'Winter Sweater', '', 12.00, '3', '7', '18', 'Forever 21', '27');
insert into Clothing_Item (Size, Name, Description, Price, DiscountID, CategoryID, CartID, BrandName, StyleID) values ('M', 'Minimalistic Shirt', 'Etiam vel augue. Vestibulum rutrum rutrum neque.', 10.47, '5', '9', '12', 'COS', '8');
insert into Clothing_Item (Size, Name, Description, Price, DiscountID, CategoryID, CartID, BrandName, StyleID) values ('M', 'Velvet Oversized Jacket', 'Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.', 94.83, '4', '14', '2', 'Carhartt', '4');
insert into Clothing_Item (Size, Name, Description, Price, DiscountID, CategoryID, CartID, BrandName, StyleID) values ('XL', 'Baggy Jeans', 'Mauris sit amet eros.', 125.50, '14', '2', '8', 'Diesel', '30');
insert into Clothing_Item (Size, Name, Description, Price, DiscountID, CategoryID, CartID, BrandName, StyleID) values ('XL', 'Button-up Shirt', 'Nulla mollis molestie lorem.', 42.99, '16', '15', '20', 'Massimo Dutti', '28');
insert into Clothing_Item (Size, Name, Description, Price, DiscountID, CategoryID, CartID, BrandName, StyleID) values ('L', 'Racer Jacket', 'In eleifend quam a odio. In hac habitasse platea dictumst.', 82.00, '2', '5', '38', 'Diesel', '22');
insert into Clothing_Item (Size, Name, Description, Price, DiscountID, CategoryID, CartID, BrandName, StyleID) values ('2XL', 'Cropped Outerwear', '', 3.15, '11', '3', '35', 'Old Navy', '21');
insert into Clothing_Item (Size, Name, Description, Price, DiscountID, CategoryID, CartID, BrandName, StyleID) values ('S', 'Logo Tee', '', 97.46, '17', '1', '19', 'Stussy', '16');
insert into Clothing_Item (Size, Name, Description, Price, DiscountID, CategoryID, CartID, BrandName, StyleID) values ('L', 'Comfy Pants', 'Vivamus tortor.', 29.75, '18', '10', '4', 'Zara', '15');
insert into Clothing_Item (Size, Name, Description, Price, DiscountID, CategoryID, CartID, BrandName, StyleID) values ('XS', 'Rain Jacket', 'Praesent lectus.', 77.54, '7', '18', '32', 'Uniqlo', '29');
insert into Clothing_Item (Size, Name, Description, Price, DiscountID, CategoryID, CartID, BrandName, StyleID) values ('S', 'High-collar Dress', '', 10.84, '1', '4', '23', 'Oak + Fort', '13');
insert into Clothing_Item (Size, Name, Description, Price, DiscountID, CategoryID, CartID, BrandName, StyleID) values ('XS', 'Ripped Denim Jacket', 'Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.', 32.85, '17', '3', '7', 'PacSun', '11');
insert into Clothing_Item (Size, Name, Description, Price, DiscountID, CategoryID, CartID, BrandName, StyleID) values ('S', 'Mini Denim Bag', '', 3.54, '2', '19', '34', 'Zara', '9');
insert into Clothing_Item (Size, Name, Description, Price, DiscountID, CategoryID, CartID, BrandName, StyleID) values ('XL', 'Basic Tee', 'Nam dui. Proin leo odio, porttitor id, consequat in, consequat ut, nulla.', 68.42, '11', '1', '28', 'Max Mara', '19');
insert into Clothing_Item (Size, Name, Description, Price, DiscountID, CategoryID, CartID, BrandName, StyleID) values ('M', 'Medium Denim Tote', '', 45.19, '19', '10', '26', 'Madewell', '10');
insert into Clothing_Item (Size, Name, Description, Price, DiscountID, CategoryID, CartID, BrandName, StyleID) values ('XL', 'Logo T-shirt', 'Morbi a ipsum. Integer a nibh.', 62.99, '12', '2', '17', 'Comme des Garcons', '17');
insert into Clothing_Item (Size, Name, Description, Price, DiscountID, CategoryID, CartID, BrandName, StyleID) values ('L', 'Wide-leg Pants', 'Suspendisse potenti. In eleifend quam a odio.', 111.35, '3', '5', '3', 'Aritzia', '24');
insert into Clothing_Item (Size, Name, Description, Price, DiscountID, CategoryID, CartID, BrandName, StyleID) values ('XL', 'Silk Fitted Skirt', 'Suspendisse potenti. In eleifend quam a odio.', 83.75, '15', '16', '27', 'Reformation', '2');
insert into Clothing_Item (Size, Name, Description, Price, DiscountID, CategoryID, CartID, BrandName, StyleID) values ('XS', 'Cute Sweater', 'Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros. .', 93.25, '7', '7', '39', 'Aritzia', '6');
insert into Clothing_Item (Size, Name, Description, Price, DiscountID, CategoryID, CartID, BrandName, StyleID) values ('XL', 'Thin knitted top', 'Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue.', 57.99, '6', '20', '40', 'Uniqlo', '23');
insert into Clothing_Item (Size, Name, Description, Price, DiscountID, CategoryID, CartID, BrandName, StyleID) values ('2XL', 'Long Velvet Dress', 'Fusce posuere felis sed lacus.', 14.25, '16', '13', '15', 'H&M', '20');
insert into Clothing_Item (Size, Name, Description, Price, DiscountID, CategoryID, CartID, BrandName, StyleID) values ('M', 'Cropped Fur Coat', 'Nulla ac enim.', 71.57, '18', '17', '21', 'Reformation', '22');
insert into Clothing_Item (Size, Name, Description, Price, DiscountID, CategoryID, CartID, BrandName, StyleID) values ('M', 'Minimalistic Cardigan', 'Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue.', 18.91, '20', '8', '11', 'PacSun', '7');
insert into Clothing_Item (Size, Name, Description, Price, DiscountID, CategoryID, CartID, BrandName, StyleID) values ('L', 'Simple Jacket', 'Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.', 53.76, '10', '18', '1', 'Patagonia', '14');
insert into Clothing_Item (Size, Name, Description, Price, DiscountID, CategoryID, CartID, BrandName, StyleID) values ('XL', 'Leather Tote', '', 48.79, '4', '6', '24', 'Urban Outfitters', '23');
insert into Clothing_Item (Size, Name, Description, Price, DiscountID, CategoryID, CartID, BrandName, StyleID) values ('S', 'Oversized Silk Shirt', 'Etiam justo.', 8.34, '13', '15', '30', 'Forever 21', '16');
insert into Clothing_Item (Size, Name, Description, Price, DiscountID, CategoryID, CartID, BrandName, StyleID) values ('3XL', 'Linen Button-up Shirt', '', 83.58, '5', '9', '10', 'Banana Republic', '27');
insert into Clothing_Item (Size, Name, Description, Price, DiscountID, CategoryID, CartID, BrandName, StyleID) values ('XL', 'Vintage Sweater', 'Quisque ut erat. Curabitur gravida nisi at nibh.', 70.31, '14', '11', '29', 'Champion', '13');
insert into Clothing_Item (Size, Name, Description, Price, DiscountID, CategoryID, CartID, BrandName, StyleID) values ('3XL', 'Oversized Jacket', '', 92.35, '8', '14', '33', 'Patagonia', '28');
insert into Clothing_Item (Size, Name, Description, Price, DiscountID, CategoryID, CartID, BrandName, StyleID) values ('S', 'Simple Oversized T-Shirt', 'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae.', 58.84, '9', '12', '13', 'Nike', '1');
insert into Clothing_Item (Size, Name, Description, Price, DiscountID, CategoryID, CartID, BrandName, StyleID) values ('XS', 'Slim Top', 'Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.', 38.65, '9', '15', '32', 'Brandy Melville', '15');
INSERT INTO Clothing_Item (Size, Name, Description, Price, DiscountID, CategoryID, CartID, BrandName, StyleID) VALUES ('M', 'Straight Jeans', 'Donec quis orci eget orci vehicula condimentum.', 40.58, '15', '2', '28', 'Levi', '10');
INSERT INTO Clothing_Item (Size, Name, Description, Price, DiscountID, CategoryID, CartID, BrandName, StyleID) VALUES ('XL', 'Oversized Hoodie', 'Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros.', 84.17, '6', '11', '27', 'Champion', '24');
INSERT INTO Clothing_Item (Size, Name, Description, Price, DiscountID, CategoryID, CartID, BrandName, StyleID) VALUES ('S', 'Casual Short Sleeve Top', '', 78.49, '14', '1', '19', 'The North Face', '6');
INSERT INTO Clothing_Item (Size, Name, Description, Price, DiscountID, CategoryID, CartID, BrandName, StyleID) VALUES ('3XL', 'Fluffy Jacket', 'Integer ac leo.', 48.85, '13', '8', '23', 'Patagonia', '11');
INSERT INTO Clothing_Item (Size, Name, Description, Price, DiscountID, CategoryID, CartID, BrandName, StyleID) VALUES ('L', 'Denim Large Tote', '', 15.10, '2', '19', '35', 'H&M', '30');
INSERT INTO Clothing_Item (Size, Name, Description, Price, DiscountID, CategoryID, CartID, BrandName, StyleID) VALUES ('L', 'Simple Denim Jacket', 'Aliquam erat volutpat.', 33.29, '8', '3', '7', 'Everlane', '29');
INSERT INTO Clothing_Item (Size, Name, Description, Price, DiscountID, CategoryID, CartID, BrandName, StyleID) VALUES ('XS', 'Thin Wool Sweater', 'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae.', 111.75, '10', '7', '30', 'Polo Ralph Lauren', '25');
INSERT INTO Clothing_Item (Size, Name, Description, Price, DiscountID, CategoryID, CartID, BrandName, StyleID) VALUES ('2XL', 'Long Leather Coat', 'Ut tellus. Nulla ut erat id mauris vulputate elementum.', 136.15, '4', '5', '15', 'Banana Republic', '2');
INSERT INTO Clothing_Item (Size, Name, Description, Price, DiscountID, CategoryID, CartID, BrandName, StyleID) VALUES ('XL', 'Nylon Jacket', 'Aenean sit amet justo. Morbi ut odio.', 65.67, '3', '18', '21', 'The North Face', '18');
INSERT INTO Clothing_Item (Size, Name, Description, Price, DiscountID, CategoryID, CartID, BrandName, StyleID) VALUES ('S', 'Summer Dress', 'In blandit ultrices enim.', 48.65, '17', '4', '10', 'Zara', '26');
INSERT INTO Clothing_Item (Size, Name, Description, Price, DiscountID, CategoryID, CartID, BrandName, StyleID) VALUES ('2XL', 'Wide-leg Linen Pants', 'Proin leo odio, porttitor id, consequat in, consequat ut, nulla.', 42.08, '20', '10', '12', 'Polo Ralph Lauren', '8');
INSERT INTO Clothing_Item (Size, Name, Description, Price, DiscountID, CategoryID, CartID, BrandName, StyleID) VALUES ('2XL', 'Simple Top', '', 76.45, '7', '9', '38', 'Stussy', '17');
INSERT INTO Clothing_Item (Size, Name, Description, Price, DiscountID, CategoryID, CartID, BrandName, StyleID) VALUES ('XS', 'Slim Skirt', 'Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet.', 44.99, '5', '16', '34', 'Madewell', '3');
INSERT INTO Clothing_Item (Size, Name, Description, Price, DiscountID, CategoryID, CartID, BrandName, StyleID) VALUES ('XL', 'Knit Sweater', 'Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero.', 30.07, '16', '20', '33', 'Uniqlo', '19');
INSERT INTO Clothing_Item (Size, Name, Description, Price, DiscountID, CategoryID, CartID, BrandName, StyleID) VALUES ('XS', 'Long Fur Coat', 'Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.', 51.23, '12', '17', '26', 'Oak + Fort', '9');
INSERT INTO Clothing_Item (Size, Name, Description, Price, DiscountID, CategoryID, CartID, BrandName, StyleID) VALUES ('M', 'Half-zip Sweater', '', 52.05, '11', '11', '9', 'Patagonia', '5');
INSERT INTO Clothing_Item (Size, Name, Description, Price, DiscountID, CategoryID, CartID, BrandName, StyleID) VALUES ('S', 'Mini Leather Cross-body Bag', 'Phasellus in felis.', 140.99, '18', '6', '6', 'Kate Spade', '21');
INSERT INTO Clothing_Item (Size, Name, Description, Price, DiscountID, CategoryID, CartID, BrandName, StyleID) VALUES ('3XL', 'Oversized Hoodie', 'Etiam justo. Etiam pretium iaculis justo.', 85.75, '1', '11', '8', 'Nike', '12');
INSERT INTO Clothing_Item (Size, Name, Description, Price, DiscountID, CategoryID, CartID, BrandName, StyleID) VALUES ('XS', 'Mini Dress', 'In hac habitasse platea dictumst. Etiam faucibus cursus urna.', 60.00, '19', '13', '24', 'Aritzia', '4');

/* Insert Item_Outfit */
insert into Item_Outfit (ItemID, OutfitID) values ('59', '3');
insert into Item_Outfit (ItemID, OutfitID) values ('29', '29');
insert into Item_Outfit (ItemID, OutfitID) values ('11', '1');
insert into Item_Outfit (ItemID, OutfitID) values ('51', '25');
insert into Item_Outfit (ItemID, OutfitID) values ('17', '9');
insert into Item_Outfit (ItemID, OutfitID) values ('45', '28');
insert into Item_Outfit (ItemID, OutfitID) values ('15', '30');
insert into Item_Outfit (ItemID, OutfitID) values ('38', '24');
insert into Item_Outfit (ItemID, OutfitID) values ('19', '47');
insert into Item_Outfit (ItemID, OutfitID) values ('7', '40');
insert into Item_Outfit (ItemID, OutfitID) values ('43', '17');
insert into Item_Outfit (ItemID, OutfitID) values ('3', '45');
insert into Item_Outfit (ItemID, OutfitID) values ('26', '7');
insert into Item_Outfit (ItemID, OutfitID) values ('57', '4');
insert into Item_Outfit (ItemID, OutfitID) values ('20', '23');
insert into Item_Outfit (ItemID, OutfitID) values ('49', '16');
insert into Item_Outfit (ItemID, OutfitID) values ('9', '46');
insert into Item_Outfit (ItemID, OutfitID) values ('41', '13');
insert into Item_Outfit (ItemID, OutfitID) values ('40', '22');
insert into Item_Outfit (ItemID, OutfitID) values ('36', '33');
insert into Item_Outfit (ItemID, OutfitID) values ('4', '14');
insert into Item_Outfit (ItemID, OutfitID) values ('37', '43');
insert into Item_Outfit (ItemID, OutfitID) values ('32', '18');
insert into Item_Outfit (ItemID, OutfitID) values ('25', '36');
insert into Item_Outfit (ItemID, OutfitID) values ('28', '50');
insert into Item_Outfit (ItemID, OutfitID) values ('1', '10');
insert into Item_Outfit (ItemID, OutfitID) values ('30', '49');
insert into Item_Outfit (ItemID, OutfitID) values ('39', '6');
insert into Item_Outfit (ItemID, OutfitID) values ('2', '41');
insert into Item_Outfit (ItemID, OutfitID) values ('16', '31');
insert into Item_Outfit (ItemID, OutfitID) values ('23', '8');
insert into Item_Outfit (ItemID, OutfitID) values ('22', '34');
insert into Item_Outfit (ItemID, OutfitID) values ('35', '35');
insert into Item_Outfit (ItemID, OutfitID) values ('5', '2');
insert into Item_Outfit (ItemID, OutfitID) values ('54', '37');
insert into Item_Outfit (ItemID, OutfitID) values ('18', '19');
insert into Item_Outfit (ItemID, OutfitID) values ('34', '26');
insert into Item_Outfit (ItemID, OutfitID) values ('60', '32');
insert into Item_Outfit (ItemID, OutfitID) values ('33', '42');
insert into Item_Outfit (ItemID, OutfitID) values ('14', '44');
insert into Item_Outfit (ItemID, OutfitID) values ('42', '20');
insert into Item_Outfit (ItemID, OutfitID) values ('6', '27');
insert into Item_Outfit (ItemID, OutfitID) values ('53', '15');
insert into Item_Outfit (ItemID, OutfitID) values ('8', '48');
insert into Item_Outfit (ItemID, OutfitID) values ('56', '38');
insert into Item_Outfit (ItemID, OutfitID) values ('46', '21');
insert into Item_Outfit (ItemID, OutfitID) values ('27', '12');
insert into Item_Outfit (ItemID, OutfitID) values ('31', '5');
insert into Item_Outfit (ItemID, OutfitID) values ('52', '11');
insert into Item_Outfit (ItemID, OutfitID) values ('24', '39');
insert into Item_Outfit (ItemID, OutfitID) values ('12', '16');
insert into Item_Outfit (ItemID, OutfitID) values ('13', '19');
insert into Item_Outfit (ItemID, OutfitID) values ('48', '44');
insert into Item_Outfit (ItemID, OutfitID) values ('21', '14');
insert into Item_Outfit (ItemID, OutfitID) values ('50', '8');
insert into Item_Outfit (ItemID, OutfitID) values ('44', '34');
insert into Item_Outfit (ItemID, OutfitID) values ('10', '10');
insert into Item_Outfit (ItemID, OutfitID) values ('47', '37');
insert into Item_Outfit (ItemID, OutfitID) values ('58', '46');
insert into Item_Outfit (ItemID, OutfitID) values ('55', '4');
insert into Item_Outfit (ItemID, OutfitID) values ('59', '7');
insert into Item_Outfit (ItemID, OutfitID) values ('9', '38');
insert into Item_Outfit (ItemID, OutfitID) values ('28', '39');
insert into Item_Outfit (ItemID, OutfitID) values ('19', '11');
insert into Item_Outfit (ItemID, OutfitID) values ('60', '29');
insert into Item_Outfit (ItemID, OutfitID) values ('4', '15');
insert into Item_Outfit (ItemID, OutfitID) values ('30', '48');
insert into Item_Outfit (ItemID, OutfitID) values ('32', '30');
insert into Item_Outfit (ItemID, OutfitID) values ('10', '26');
insert into Item_Outfit (ItemID, OutfitID) values ('58', '23');
insert into Item_Outfit (ItemID, OutfitID) values ('5', '12');
insert into Item_Outfit (ItemID, OutfitID) values ('29', '3');
insert into Item_Outfit (ItemID, OutfitID) values ('47', '42');
insert into Item_Outfit (ItemID, OutfitID) values ('1', '21');
insert into Item_Outfit (ItemID, OutfitID) values ('40', '5');
insert into Item_Outfit (ItemID, OutfitID) values ('44', '43');
insert into Item_Outfit (ItemID, OutfitID) values ('41', '28');
insert into Item_Outfit (ItemID, OutfitID) values ('11', '22');
insert into Item_Outfit (ItemID, OutfitID) values ('34', '35');
insert into Item_Outfit (ItemID, OutfitID) values ('57', '6');
insert into Item_Outfit (ItemID, OutfitID) values ('24', '13');
insert into Item_Outfit (ItemID, OutfitID) values ('50', '27');
insert into Item_Outfit (ItemID, OutfitID) values ('2', '33');
insert into Item_Outfit (ItemID, OutfitID) values ('26', '25');
insert into Item_Outfit (ItemID, OutfitID) values ('48', '20');
insert into Item_Outfit (ItemID, OutfitID) values ('53', '17');
insert into Item_Outfit (ItemID, OutfitID) values ('35', '31');
insert into Item_Outfit (ItemID, OutfitID) values ('37', '47');
insert into Item_Outfit (ItemID, OutfitID) values ('8', '36');
insert into Item_Outfit (ItemID, OutfitID) values ('52', '40');
insert into Item_Outfit (ItemID, OutfitID) values ('15', '50');
insert into Item_Outfit (ItemID, OutfitID) values ('33', '9');
insert into Item_Outfit (ItemID, OutfitID) values ('13', '18');
insert into Item_Outfit (ItemID, OutfitID) values ('12', '49');
insert into Item_Outfit (ItemID, OutfitID) values ('22', '41');
insert into Item_Outfit (ItemID, OutfitID) values ('21', '1');
insert into Item_Outfit (ItemID, OutfitID) values ('49', '45');
insert into Item_Outfit (ItemID, OutfitID) values ('25', '24');
insert into Item_Outfit (ItemID, OutfitID) values ('16', '2');
insert into Item_Outfit (ItemID, OutfitID) values ('17', '32');
insert into Item_Outfit (ItemID, OutfitID) values ('56', '22');
insert into Item_Outfit (ItemID, OutfitID) values ('27', '5');
insert into Item_Outfit (ItemID, OutfitID) values ('36', '38');
insert into Item_Outfit (ItemID, OutfitID) values ('42', '6');
insert into Item_Outfit (ItemID, OutfitID) values ('31', '44');
insert into Item_Outfit (ItemID, OutfitID) values ('7', '13');
insert into Item_Outfit (ItemID, OutfitID) values ('54', '36');
insert into Item_Outfit (ItemID, OutfitID) values ('20', '32');
insert into Item_Outfit (ItemID, OutfitID) values ('43', '12');
insert into Item_Outfit (ItemID, OutfitID) values ('23', '48');
insert into Item_Outfit (ItemID, OutfitID) values ('3', '46');
insert into Item_Outfit (ItemID, OutfitID) values ('45', '21');
insert into Item_Outfit (ItemID, OutfitID) values ('38', '20');
insert into Item_Outfit (ItemID, OutfitID) values ('39', '4');
insert into Item_Outfit (ItemID, OutfitID) values ('55', '28');
insert into Item_Outfit (ItemID, OutfitID) values ('18', '10');
insert into Item_Outfit (ItemID, OutfitID) values ('14', '29');
insert into Item_Outfit (ItemID, OutfitID) values ('46', '16');
insert into Item_Outfit (ItemID, OutfitID) values ('6', '40');
insert into Item_Outfit (ItemID, OutfitID) values ('51', '7');
insert into Item_Outfit (ItemID, OutfitID) values ('9', '8');
insert into Item_Outfit (ItemID, OutfitID) values ('29', '33');
insert into Item_Outfit (ItemID, OutfitID) values ('42', '50');
insert into Item_Outfit (ItemID, OutfitID) values ('2', '2');
insert into Item_Outfit (ItemID, OutfitID) values ('52', '39');
insert into Item_Outfit (ItemID, OutfitID) values ('18', '27');
insert into Item_Outfit (ItemID, OutfitID) values ('47', '7');
insert into Item_Outfit (ItemID, OutfitID) values ('21', '17');
insert into Item_Outfit (ItemID, OutfitID) values ('55', '1');
insert into Item_Outfit (ItemID, OutfitID) values ('35', '9');
insert into Item_Outfit (ItemID, OutfitID) values ('36', '19');
insert into Item_Outfit (ItemID, OutfitID) values ('39', '45');
insert into Item_Outfit (ItemID, OutfitID) values ('6', '18');
insert into Item_Outfit (ItemID, OutfitID) values ('24', '41');
insert into Item_Outfit (ItemID, OutfitID) values ('46', '35');
insert into Item_Outfit (ItemID, OutfitID) values ('31', '31');
insert into Item_Outfit (ItemID, OutfitID) values ('1', '34');
insert into Item_Outfit (ItemID, OutfitID) values ('3', '42');
insert into Item_Outfit (ItemID, OutfitID) values ('33', '30');
insert into Item_Outfit (ItemID, OutfitID) values ('25', '23');
insert into Item_Outfit (ItemID, OutfitID) values ('51', '26');
insert into Item_Outfit (ItemID, OutfitID) values ('49', '14');
insert into Item_Outfit (ItemID, OutfitID) values ('13', '43');
insert into Item_Outfit (ItemID, OutfitID) values ('26', '24');
insert into Item_Outfit (ItemID, OutfitID) values ('7', '25');
insert into Item_Outfit (ItemID, OutfitID) values ('43', '15');
insert into Item_Outfit (ItemID, OutfitID) values ('16', '3');
insert into Item_Outfit (ItemID, OutfitID) values ('28', '49');
insert into Item_Outfit (ItemID, OutfitID) values ('4', '11');
insert into Item_Outfit (ItemID, OutfitID) values ('48', '47');
insert into Item_Outfit (ItemID, OutfitID) values ('11', '13');
insert into Item_Outfit (ItemID, OutfitID) values ('56', '17');
insert into Item_Outfit (ItemID, OutfitID) values ('38', '48');
insert into Item_Outfit (ItemID, OutfitID) values ('54', '30');
insert into Item_Outfit (ItemID, OutfitID) values ('41', '42');
insert into Item_Outfit (ItemID, OutfitID) values ('60', '22');
insert into Item_Outfit (ItemID, OutfitID) values ('27', '33');
insert into Item_Outfit (ItemID, OutfitID) values ('20', '12');
insert into Item_Outfit (ItemID, OutfitID) values ('58', '18');
insert into Item_Outfit (ItemID, OutfitID) values ('19', '43');
insert into Item_Outfit (ItemID, OutfitID) values ('5', '29');
insert into Item_Outfit (ItemID, OutfitID) values ('17', '14');
insert into Item_Outfit (ItemID, OutfitID) values ('30', '30');
insert into Item_Outfit (ItemID, OutfitID) values ('45', '39');
insert into Item_Outfit (ItemID, OutfitID) values ('32', '34');
insert into Item_Outfit (ItemID, OutfitID) values ('37', '11');
insert into Item_Outfit (ItemID, OutfitID) values ('8', '32');
insert into Item_Outfit (ItemID, OutfitID) values ('10', '40');
insert into Item_Outfit (ItemID, OutfitID) values ('14', '19');
insert into Item_Outfit (ItemID, OutfitID) values ('53', '7');
insert into Item_Outfit (ItemID, OutfitID) values ('57', '25');
insert into Item_Outfit (ItemID, OutfitID) values ('15', '20');
insert into Item_Outfit (ItemID, OutfitID) values ('50', '46');
insert into Item_Outfit (ItemID, OutfitID) values ('23', '16');
insert into Item_Outfit (ItemID, OutfitID) values ('44', '3');
insert into Item_Outfit (ItemID, OutfitID) values ('34', '37');
insert into Item_Outfit (ItemID, OutfitID) values ('22', '15');
insert into Item_Outfit (ItemID, OutfitID) values ('59', '10');
insert into Item_Outfit (ItemID, OutfitID) values ('12', '39');
insert into Item_Outfit (ItemID, OutfitID) values ('40', '35');
insert into Item_Outfit (ItemID, OutfitID) values ('56', '5');
insert into Item_Outfit (ItemID, OutfitID) values ('3', '28');
insert into Item_Outfit (ItemID, OutfitID) values ('44', '23');
insert into Item_Outfit (ItemID, OutfitID) values ('15', '2');
insert into Item_Outfit (ItemID, OutfitID) values ('57', '31');
insert into Item_Outfit (ItemID, OutfitID) values ('38', '6');
insert into Item_Outfit (ItemID, OutfitID) values ('15', '9');
insert into Item_Outfit (ItemID, OutfitID) values ('52', '38');
insert into Item_Outfit (ItemID, OutfitID) values ('31', '4');
insert into Item_Outfit (ItemID, OutfitID) values ('47', '1');
insert into Item_Outfit (ItemID, OutfitID) values ('2', '50');
insert into Item_Outfit (ItemID, OutfitID) values ('1', '44');
insert into Item_Outfit (ItemID, OutfitID) values ('11', '27');
insert into Item_Outfit (ItemID, OutfitID) values ('49', '24');
insert into Item_Outfit (ItemID, OutfitID) values ('18', '45');
insert into Item_Outfit (ItemID, OutfitID) values ('43', '41');
insert into Item_Outfit (ItemID, OutfitID) values ('14', '8');
insert into Item_Outfit (ItemID, OutfitID) values ('41', '21');
insert into Item_Outfit (ItemID, OutfitID) values ('40', '26');
insert into Item_Outfit (ItemID, OutfitID) values ('55', '47');

/* Insert Purchase History */
INSERT INTO Purchase_History (PurchaseDate, PurchaseCost, PurchaseAesthetic, UserID) VALUES ('2023-09-17 04:32:03', 90.04, 'Vintage', '8');
INSERT INTO Purchase_History (PurchaseDate, PurchaseCost, PurchaseAesthetic, UserID) VALUES ('2023-05-06 16:19:14', 162.04, 'Quiet Luxury', '12');
INSERT INTO Purchase_History (PurchaseDate, PurchaseCost, PurchaseAesthetic, UserID) VALUES ('2023-05-07 00:08:20', 29.97, 'Cottagecore', '19');
INSERT INTO Purchase_History (PurchaseDate, PurchaseCost, PurchaseAesthetic, UserID) VALUES ('2023-06-27 17:05:39', 81.37, 'Streetwear', '5');
INSERT INTO Purchase_History (PurchaseDate, PurchaseCost, PurchaseAesthetic, UserID) VALUES ('2022-12-28 19:29:04', 28.33, 'Clean', '40');
INSERT INTO Purchase_History (PurchaseDate, PurchaseCost, PurchaseAesthetic, UserID) VALUES ('2023-06-15 20:42:21', 81.06, 'Vintage', '27');
INSERT INTO Purchase_History (PurchaseDate, PurchaseCost, PurchaseAesthetic, UserID) VALUES ('2023-04-09 19:20:55', 53.31, 'Clean', '3');
INSERT INTO Purchase_History (PurchaseDate, PurchaseCost, PurchaseAesthetic, UserID) VALUES ('2023-10-06 01:56:50', 58.65, 'Academia', '2');
INSERT INTO Purchase_History (PurchaseDate, PurchaseCost, PurchaseAesthetic, UserID) VALUES ('2023-09-25 12:46:10', 148.71, 'Quiet Luxury', '20');
INSERT INTO Purchase_History (PurchaseDate, PurchaseCost, PurchaseAesthetic, UserID) VALUES ('2023-01-14 07:23:36', 57.65, 'Y2K', '4');
INSERT INTO Purchase_History (PurchaseDate, PurchaseCost, PurchaseAesthetic, UserID) VALUES ('2023-06-17 16:02:38', 45.53, 'Streetwear', '29');
INSERT INTO Purchase_History (PurchaseDate, PurchaseCost, PurchaseAesthetic, UserID) VALUES ('2023-11-18 09:52:17', 16.28, 'Academia', '25');
INSERT INTO Purchase_History (PurchaseDate, PurchaseCost, PurchaseAesthetic, UserID) VALUES ('2023-11-29 10:09:41', 81.47, 'Quiet Luxury', '11');
INSERT INTO Purchase_History (PurchaseDate, PurchaseCost, PurchaseAesthetic, UserID) VALUES ('2023-05-04 16:24:52', 65.30, 'Coquette', '1');
INSERT INTO Purchase_History (PurchaseDate, PurchaseCost, PurchaseAesthetic, UserID) VALUES ('2023-07-11 21:47:42', 92.84, 'Gorpcore', '38');
INSERT INTO Purchase_History (PurchaseDate, PurchaseCost, PurchaseAesthetic, UserID) VALUES ('2023-10-15 09:39:57', 42.71, 'Gorpcore', '9');
INSERT INTO Purchase_History (PurchaseDate, PurchaseCost, PurchaseAesthetic, UserID) VALUES ('2023-02-16 23:01:34', 36.25, 'Vintage', '36');
INSERT INTO Purchase_History (PurchaseDate, PurchaseCost, PurchaseAesthetic, UserID) VALUES ('2022-12-16 18:28:48', 15.21, 'Coquette', '32');
INSERT INTO Purchase_History (PurchaseDate, PurchaseCost, PurchaseAesthetic, UserID) VALUES ('2023-11-15 01:06:26', 81.35, 'Clean', '18');
INSERT INTO Purchase_History (PurchaseDate, PurchaseCost, PurchaseAesthetic, UserID) VALUES ('2023-08-08 16:32:29', 15.42, 'Cottagecore', '22');
INSERT INTO Purchase_History (PurchaseDate, PurchaseCost, PurchaseAesthetic, UserID) VALUES ('2023-08-16 19:56:55', 82.38, 'Clean', '23');
INSERT INTO Purchase_History (PurchaseDate, PurchaseCost, PurchaseAesthetic, UserID) VALUES ('2023-06-30 11:58:17', 52.66, 'Gorpcore', '16');
INSERT INTO Purchase_History (PurchaseDate, PurchaseCost, PurchaseAesthetic, UserID) VALUES ('2022-12-14 03:48:45', 52.39, 'Gorpcore', '21');
INSERT INTO Purchase_History (PurchaseDate, PurchaseCost, PurchaseAesthetic, UserID) VALUES ('2022-12-22 22:25:12', 71.85, 'Academia', '10');
INSERT INTO Purchase_History (PurchaseDate, PurchaseCost, PurchaseAesthetic, UserID) VALUES ('2023-09-09 02:30:26', 19.91, 'Y2K', '35');
INSERT INTO Purchase_History (PurchaseDate, PurchaseCost, PurchaseAesthetic, UserID) VALUES ('2023-04-18 18:47:59', 25.74, 'Clean', '30');
INSERT INTO Purchase_History (PurchaseDate, PurchaseCost, PurchaseAesthetic, UserID) VALUES ('2023-08-21 03:13:47', 61.33, 'Gorpcore', '26');
INSERT INTO Purchase_History (PurchaseDate, PurchaseCost, PurchaseAesthetic, UserID) VALUES ('2022-12-22 00:07:34', 46.13, 'Coquette', '17');
INSERT INTO Purchase_History (PurchaseDate, PurchaseCost, PurchaseAesthetic, UserID) VALUES ('2023-07-04 21:00:07', 46.13, 'Gorpcore', '28');
INSERT INTO Purchase_History (PurchaseDate, PurchaseCost, PurchaseAesthetic, UserID) VALUES ('2022-12-30 18:18:13', 93.55, 'Gorpcore', '14');
INSERT INTO Purchase_History (PurchaseDate, PurchaseCost, PurchaseAesthetic, UserID) VALUES ('2023-08-14 01:36:02', 52.17, 'Streetwear', '6');
INSERT INTO Purchase_History (PurchaseDate, PurchaseCost, PurchaseAesthetic, UserID) VALUES ('2023-07-27 13:45:01', 42.42, 'Y2K', '24');
INSERT INTO Purchase_History (PurchaseDate, PurchaseCost, PurchaseAesthetic, UserID) VALUES ('2023-10-11 18:24:11', 90.64, 'Quiet Luxury', '31');
INSERT INTO Purchase_History (PurchaseDate, PurchaseCost, PurchaseAesthetic, UserID) VALUES ('2023-03-16 05:30:58', 178.88, 'Quiet Luxury', '37');
INSERT INTO Purchase_History (PurchaseDate, PurchaseCost, PurchaseAesthetic, UserID) VALUES ('2023-06-14 16:30:26', 93.78, 'Gorpcore', '34');
INSERT INTO Purchase_History (PurchaseDate, PurchaseCost, PurchaseAesthetic, UserID) VALUES ('2023-08-16 16:45:37', 138.51, 'Clean', '15');
INSERT INTO Purchase_History (PurchaseDate, PurchaseCost, PurchaseAesthetic, UserID) VALUES ('2023-06-02 09:38:10', 73.43, 'Grunge', '7');
INSERT INTO Purchase_History (PurchaseDate, PurchaseCost, PurchaseAesthetic, UserID) VALUES ('2023-04-19 02:31:59', 178.89, 'Quiet Luxury', '13');
INSERT INTO Purchase_History (PurchaseDate, PurchaseCost, PurchaseAesthetic, UserID) VALUES ('2023-01-25 12:11:49', 53.32, 'Grunge', '39');
INSERT INTO Purchase_History (PurchaseDate, PurchaseCost, PurchaseAesthetic, UserID) VALUES ('2023-11-12 07:09:22', 87.13, 'Vintage', '33');
INSERT INTO Purchase_History (PurchaseDate, PurchaseCost, PurchaseAesthetic, UserID) VALUES ('2023-11-08 22:43:58', 96.31, 'Academia', '9');
INSERT INTO Purchase_History (PurchaseDate, PurchaseCost, PurchaseAesthetic, UserID) VALUES ('2022-12-10 17:29:32', 124.67, 'Quiet Luxury', '16');
INSERT INTO Purchase_History (PurchaseDate, PurchaseCost, PurchaseAesthetic, UserID) VALUES ('2023-01-13 07:25:27', 51.55, 'Clean', '20');
INSERT INTO Purchase_History (PurchaseDate, PurchaseCost, PurchaseAesthetic, UserID) VALUES ('2023-07-05 06:54:28', 38.58, 'Coquette', '23');
INSERT INTO Purchase_History (PurchaseDate, PurchaseCost, PurchaseAesthetic, UserID) VALUES ('2023-02-15 08:43:25', 86.39, 'Vintage', '34');
INSERT INTO Purchase_History (PurchaseDate, PurchaseCost, PurchaseAesthetic, UserID) VALUES ('2023-11-27 01:36:09', 14.69, 'Grunge', '37');
INSERT INTO Purchase_History (PurchaseDate, PurchaseCost, PurchaseAesthetic, UserID) VALUES ('2023-09-22 08:04:37', 71.89, 'Clean', '7');
INSERT INTO Purchase_History (PurchaseDate, PurchaseCost, PurchaseAesthetic, UserID) VALUES ('2023-02-12 14:50:59', 78.37, 'Quiet Luxury', '8');
INSERT INTO Purchase_History (PurchaseDate, PurchaseCost, PurchaseAesthetic, UserID) VALUES ('2023-11-04 21:46:37', 96.42, 'Streetwear', '30');
INSERT INTO Purchase_History (PurchaseDate, PurchaseCost, PurchaseAesthetic, UserID) VALUES ('2023-01-06 15:09:00', 17.14, 'Grunge', '24');

/* Insert Purchase History_Outfit */
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('40', '17');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('48', '23');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('23', '25');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('6', '30');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('16', '31');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('49', '44');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('44', '36');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('3', '18');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('9', '41');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('35', '14');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('8', '35');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('2', '45');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('14', '2');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('19', '43');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('4', '38');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('21', '34');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('32', '13');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('10', '26');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('26', '10');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('45', '16');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('13', '6');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('12', '24');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('33', '39');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('30', '9');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('47', '21');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('25', '37');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('38', '12');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('41', '15');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('22', '7');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('34', '4');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('37', '27');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('28', '19');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('7', '42');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('1', '1');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('46', '33');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('11', '46');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('50', '49');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('18', '50');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('15', '40');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('39', '47');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('17', '29');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('27', '22');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('42', '48');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('36', '3');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('31', '32');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('5', '28');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('20', '11');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('29', '20');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('43', '5');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('24', '8');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('48', '22');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('10', '36');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('17', '18');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('25', '2');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('34', '14');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('45', '21');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('39', '44');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('47', '11');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('7', '39');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('13', '29');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('40', '14');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('26', '43');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('14', '5');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('38', '13');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('43', '35');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('27', '33');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('44', '1');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('6', '31');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('12', '12');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('2', '6');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('16', '20');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('18', '47');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('21', '42');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('11', '17');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('8', '16');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('30', '38');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('50', '7');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('32', '24');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('15', '3');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('20', '19');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('3', '37');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('31', '8');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('4', '32');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('36', '23');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('49', '50');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('33', '46');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('1', '40');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('28', '26');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('24', '28');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('23', '35');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('5', '48');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('29', '45');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('22', '30');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('9', '15');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('37', '9');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('19', '27');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('46', '10');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('35', '34');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('42', '41');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('41', '49');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('49', '11');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('48', '2');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('50', '6');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('25', '31');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('24', '30');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('16', '33');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('41', '48');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('6', '34');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('19', '7');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('12', '15');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('43', '38');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('35', '1');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('42', '16');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('34', '44');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('28', '25');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('10', '21');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('40', '50');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('31', '43');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('9', '27');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('37', '3');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('13', '23');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('20', '41');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('27', '10');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('44', '9');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('17', '22');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('15', '8');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('18', '42');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('14', '19');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('3', '27');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('2', '28');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('26', '45');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('29', '26');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('7', '32');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('23', '13');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('38', '5');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('21', '4');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('1', '20');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('8', '36');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('45', '14');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('33', '18');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('5', '39');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('36', '12');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('39', '29');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('4', '47');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('22', '24');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('30', '40');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('32', '49');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('11', '35');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('47', '46');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('46', '17');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('28', '4');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('10', '46');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('37', '18');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('4', '17');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('3', '31');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('2', '23');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('46', '29');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('19', '8');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('8', '22');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('15', '34');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('33', '26');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('26', '9');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('18', '38');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('11', '5');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('36', '6');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('17', '45');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('30', '39');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('50', '11');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('41', '36');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('6', '21');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('48', '47');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('12', '19');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('24', '48');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('21', '20');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('14', '43');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('49', '24');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('16', '27');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('43', '33');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('44', '30');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('40', '49');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('5', '2');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('31', '12');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('35', '50');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('38', '42');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('29', '41');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('13', '13');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('22', '1');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('47', '35');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('23', '3');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('34', '15');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('27', '40');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('42', '37');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('32', '7');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('39', '28');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('25', '44');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('9', '14');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('7', '16');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('1', '32');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('45', '25');
insert into PurchaseHistory_Outfit (PurchaseHistoryID, OutfitID) values ('20', '10');






