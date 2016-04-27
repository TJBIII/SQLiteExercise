-- Provide a query showing Customers (just their full names, customer ID and country) who are not in the US.
SELECT
c.FirstName || ' ' || c.LastName as FullName,
c.CustomerId,
c.Country
FROM Customer c
WHERE c.Country != 'USA';

-- Provide a query only showing the Customers from Brazil.
SELECT
c.FirstName || ' ' || c.LastName as FullName,
c.CustomerId,
c.Country
FROM Customer c
WHERE c.Country == 'Brazil';


-- Provide a query showing the Invoices of customers who are from Brazil. The resultant table should show the customer's full name, Invoice ID, Date of the invoice and billing country.
SELECT
c.FirstName || ' ' || c.LastName as FullName,
c.Country,
i.InvoiceId,
i.InvoiceDate,
i.BillingCountry
FROM Customer c
INNER JOIN Invoice i ON c.CustomerId =  i.CustomerId
WHERE c.Country == 'Brazil';


-- Provide a query showing only the Employees who are Sales Agents.
SELECT * FROM Employee e
WHERE e.Title == 'Sales Support Agent';


-- Provide a query showing a unique list of billing countries from the Invoice table.
SELECT DISTINCT
i.BillingCountry
FROM Invoice i;


-- Provide a query that shows the invoices associated with each sales agent. The resultant table should include the Sales Agent's full name.
SELECT 
 e.FirstName || ' ' || e.LastName AS SalesAgentName,
 i.InvoiceId
FROM Invoice i
INNER JOIN Customer c
INNER JOIN Employee e
WHERE i.CustomerId = c.CustomerId AND c.SupportRepId = e.EmployeeID
ORDER BY SalesAgentName;


-- Provide a query that shows the Invoice Total, Customer name, Country and Sale Agent name for all invoices and customers.
SELECT 
 e.FirstName || ' ' || e.LastName AS SalesAgentName,
i.InvoiceId,
i.Total,
c.FirstName || ' ' || c.LastName AS Customer
FROM Invoice i
INNER JOIN Customer c
INNER JOIN Employee e
WHERE i.CustomerId = c.CustomerId AND c.SupportRepId = e.EmployeeID
ORDER BY SalesAgentName;


-- How many Invoices were there in 2009 and 2011? What are the respective total sales for each of those years?(include both the answers and the queries used to find the answers)
166 invoices

SELECT COUNT(*) FROM Invoice i
WHERE i.InvoiceDate LIKE '2009%' OR i.InvoiceDate LIKE '2011%';



-- Looking at the InvoiceLine table, provide a query that COUNTs the number of line items for Invoice ID 37.
SELECT COUNT(*) FROM InvoiceLine il
WHERE il.InvoiceId = 37;

-- Looking at the InvoiceLine table, provide a query that COUNTs the number of line items for each Invoice. HINT: GROUP BY
SELECT
il.InvoiceId, 
COUNT(*) as NumberOfLineItems
 FROM InvoiceLine il
GROUP BY il.InvoiceId;


-- Provide a query that includes the track name with each invoice line item.
SELECT
il.InvoiceLineId,
t.Name
FROM InvoiceLine il
INNER JOIN Track t
WHERE t.TrackId = il.TrackId;

-- Provide a query that includes the purchased track name AND artist name with each invoice line item.
SELECT
il.InvoiceLineId,
t.Name,
a.Title as AlbumTitle
FROM InvoiceLine il
INNER JOIN Track t
INNER JOIN Album a
WHERE a.AlbumId = t.AlbumId AND t.TrackId = il.TrackId;

-- Provide a query that shows the # of invoices per country. HINT: GROUP BY
SELECT i.BillingCountry, COUNT(*) AS NumberOfInvoices
FROM Invoice i
GROUP BY i.BillingCountry;

-- Provide a query that shows the total number of tracks in each playlist. The Playlist name should be include on the resulant table.

SELECT
p.Name,
COUNT(*) AS NumberOfTracks
FROM Track t
INNER JOIN PlaylistTrack pt
INNER JOIN Playlist p
WHERE t.TrackId = pt.TrackId AND pt.PlaylistId = p.PlaylistId
GROUP By P.Name;


-- Provide a query that shows all the Tracks, but displays no IDs. The resultant table should include the Album name, Media type and Genre.
SELECT 
t.Name as Track,
a.Title as Album,
g.Name as Genre,
m.Name as MediaType
FROM Track t
INNER JOIN MediaType m
INNER JOIN Album a
INNER JOIN Genre g
WHERE m.MediaTypeId = t.MediaTypeId AND a.AlbumId = t.AlbumId AND g.GenreId = t.GenreId


-- Provide a query that shows all Invoices but includes the # of invoice line items.
SELECT 
i.InvoiceId,
COUNT(il.InvoiceId) AS NumberOfLineItems
 FROM Invoice i
INNER JOIN InvoiceLine il
WHERE i.InvoiceId = il.InvoiceID
GROUP BY i.InvoiceId;

-- Provide a query that shows total sales made by each sales agent.
SELECT 
 COUNT(i.Total) AS Sales,
 e.FirstName || ' ' || e.LastName AS SalesAgentName
FROM Invoice i
INNER JOIN Customer c
INNER JOIN Employee e
WHERE i.CustomerId = c.CustomerId AND c.SupportRepId = e.EmployeeID
GROUP BY e.EmployeeId;

-- Which sales agent made the most in sales in 2009? HINT: MAX //MARGARET PARK
SELECT 
 MAX(Sales),
 SalesAgentName
FROM (SELECT 
 COUNT(i.Total) AS Sales,
 e.FirstName || ' ' || e.LastName AS SalesAgentName
FROM Invoice i
INNER JOIN Customer c
INNER JOIN Employee e
WHERE i.CustomerId = c.CustomerId AND c.SupportRepId = e.EmployeeID AND i.InvoiceDate Like '2009%'
GROUP BY e.EmployeeId);


-- Which sales agent made the most in sales over all? //JANE PEACOCK
SELECT 
MAX(Sales),
 SalesAgentName
FROM (SELECT 
 COUNT(i.Total) AS Sales,
 e.FirstName || ' ' || e.LastName AS SalesAgentName
FROM Invoice i
INNER JOIN Customer c
INNER JOIN Employee e
WHERE i.CustomerId = c.CustomerId AND c.SupportRepId = e.EmployeeID
GROUP BY e.EmployeeId);


-- Provide a query that shows the # of customers assigned to each sales agent.
SELECT 
 COUNT(c.CustomerId) as Customers,
 e.FirstName || ' ' || e.LastName as SalesAgentName
FROM Customer c
INNER JOIN Employee e
WHERE c.SupportRepId == e.EmployeeId
GROUP BY e.EmployeeId


-- Provide a query that shows the total sales per country. Which country's customers spent the most?
SELECT 
 COUNT(i.InvoiceId) AS Sales,
 i.BillingCountry,
 ROUND(SUM(i.Total), 2) AS MoneySpent
FROM Invoice i
INNER JOIN Customer c
INNER JOIN Employee e
WHERE i.CustomerId = c.CustomerId AND c.SupportRepId = e.EmployeeID
GROUP BY i.BillingCountry
ORDER BY MoneySpent DESC;

-- Provide a query that shows the most purchased track of 2013.
SELECT
 t.TrackId,
 t.Name,
 COUNT(il.Quantity) as Purchases
FROM InvoiceLine il
INNER JOIN Invoice i
INNER JOIN Track t
WHERE il.InvoiceId == i.InvoiceId AND t.TrackId == il.TrackId AND i.InvoiceDate LIKE '2013%'
GROUP BY t.TrackId
ORDER BY Purchases DESC;

-- Provide a query that shows the top 5 most purchased tracks over all.
SELECT
 t.TrackId,
 t.Name,
 COUNT(il.Quantity) as Purchases
FROM InvoiceLine il
INNER JOIN Invoice i
INNER JOIN Track t
WHERE il.InvoiceId == i.InvoiceId AND t.TrackId == il.TrackId
GROUP BY t.TrackId
ORDER BY Purchases DESC
LIMIT 5;

-- Provide a query that shows the top 3 best selling artists.
SELECT
t.TrackId,
art.Name,
COUNT(il.Quantity) as Purchases
FROM InvoiceLine il
INNER JOIN Invoice i
INNER JOIN Track t
INNER JOIN Artist art
INNER JOIN Album a
WHERE il.InvoiceId == i.InvoiceId AND t.TrackId == il.TrackId AND t.AlbumId = a.AlbumId AND a.ArtistID = art.ArtistID
GROUP BY art.Name
ORDER BY Purchases DESC
LIMIT 3;

-- Provide a query that shows the most purchased Media Type.
SELECT 
m.Name,
COUNT(*) as Number
FROM InvoiceLine il
INNER JOIN Track t
INNER JOIN MediaType m
WHERE il.TrackId = t.TrackId AND t.MediaTypeId = m.MediaTypeId
GROUP BY m.Name
ORDER BY Number DESC;


