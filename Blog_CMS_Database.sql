-- Create Database
CREATE DATABASE Blog_CMS;
GO

USE Blog_CMS;
GO






-- Create Tables
CREATE TABLE Users (
    Id INT PRIMARY KEY IDENTITY(1,1),
    Username NVARCHAR(50) NOT NULL UNIQUE,
    Email NVARCHAR(100) NOT NULL UNIQUE,
    PasswordHash NVARCHAR(255) NOT NULL,
    Role NVARCHAR(10) NOT NULL DEFAULT 'User',
    CreatedAt DATETIME2 NOT NULL DEFAULT GETDATE()
);

select * from users;


CREATE TABLE BlogPosts (
    Id INT PRIMARY KEY IDENTITY(1,1),
    Title NVARCHAR(255) NOT NULL,
    Content NVARCHAR(MAX) NOT NULL,
    Excerpt NVARCHAR(500),
    Slug NVARCHAR(255) NOT NULL UNIQUE,
    FeaturedImageUrl NVARCHAR(500),
    AuthorId INT NOT NULL FOREIGN KEY REFERENCES Users(Id),
    Status NVARCHAR(20) NOT NULL DEFAULT 'Draft', -- Draft, Pending, Published, Rejected
    PublishedAt DATETIME2,
    CreatedAt DATETIME2 NOT NULL DEFAULT GETDATE(),
    UpdatedAt DATETIME2 NOT NULL DEFAULT GETDATE(),
    MetaTitle NVARCHAR(255),
    MetaDescription NVARCHAR(500),
    Tags NVARCHAR(500)
);
select * from BlogPosts;

CREATE TABLE Categories (
    Id INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(100) NOT NULL UNIQUE,
    Slug NVARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE BlogPostCategories (
    BlogPostId INT NOT NULL FOREIGN KEY REFERENCES BlogPosts(Id),
    CategoryId INT NOT NULL FOREIGN KEY REFERENCES Categories(Id),
    PRIMARY KEY (BlogPostId, CategoryId)
);

-- Insert Default Data
INSERT INTO Users (Username, Email, PasswordHash, Role) 
VALUES 
('admin', 'admin@blogcms.com', '$2a$11$rL4UZ3bR3Wqk7K7K7K7K7eK7K7K7K7K7K7K7K7K7K7K7K7K7K7K', 'Admin'),
('author1', 'author1@blogcms.com', '$2a$11$rL4UZ3bR3Wqk7K7K7K7K7eK7K7K7K7K7K7K7K7K7K7K7K7K7K7K', 'User');

INSERT INTO Categories (Name, Slug) VALUES
('Technology', 'technology'),
('Lifestyle', 'lifestyle'),
('Travel', 'travel'),
('Food', 'food');

INSERT INTO BlogPosts (Title, Content, Excerpt, Slug, AuthorId, Status, PublishedAt, MetaTitle, MetaDescription) 
VALUES
('Getting Started with React', 'React is a JavaScript library for building user interfaces...', 'Learn the basics of React programming', 'getting-started-with-react', 2, 'Published', GETDATE(), 'React Tutorial', 'Learn React fundamentals'),
('ASP.NET Core Web API', 'Building RESTful APIs with ASP.NET Core...', 'Create powerful APIs with ASP.NET Core', 'aspnet-core-web-api', 2, 'Published', GETDATE(), 'ASP.NET Core API Guide', 'Build REST APIs with ASP.NET Core');
GO


select * from Categories;

SELECT * FROM Users WHERE Username = 'NewAdmin';
UPDATE Users SET Role = 'Admin' WHERE Username = 'NewAdmin';
UPDATE Users 
SET PasswordHash = '$2a$11$L1r5YzBqWJk8M2n9T0vC4eR7sA1dF3gH6iP5oU8xV0yZ2bN4cE7w' 
WHERE Username = 'admin';


-- Fix NULL values in existing posts
UPDATE BlogPosts SET Excerpt = '' WHERE Excerpt IS NULL;
UPDATE BlogPosts SET FeaturedImageUrl = '' WHERE FeaturedImageUrl IS NULL;
UPDATE BlogPosts SET MetaTitle = '' WHERE MetaTitle IS NULL;
UPDATE BlogPosts SET MetaDescription = '' WHERE MetaDescription IS NULL;
UPDATE BlogPosts SET Tags = '' WHERE Tags IS NULL;

-- Ensure Slug is never NULL
UPDATE BlogPosts SET Slug = LOWER(REPLACE(REPLACE(REPLACE(Title, ' ', '-'), '''', ''), '"', '')) WHERE Slug IS NULL;

-- Check for any posts without authors and fix them
UPDATE BlogPosts SET AuthorId = (SELECT TOP 1 Id FROM Users WHERE Role = 'User') 
WHERE AuthorId NOT IN (SELECT Id FROM Users) OR AuthorId IS NULL;