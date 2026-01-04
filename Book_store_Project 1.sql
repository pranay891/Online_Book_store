create table book(
                   Book_ID serial primary key,
				   Title varchar(100),
				   Author varchar(100),
				   Genre varchar(100),
				   Published_Year int,
				   Price numeric(10,2),
				   stock int
);
drop table book;

create table customer(
                   Customer_ID serial primary key,
				   Name varchar(100),
				   Email varchar(100),
				   Phone varchar(100),
				   City varchar(100),
				   Country varchar(150)
);
drop table customer;

create table orders(
                   Order_ID serial primary key,
				   Customer_ID int references customer(Customer_ID),
				   Book_ID int references Book(Book_ID),
				   Order_Date Date,
				   Quantity int,
				   Total_amount numeric(10,2)
);
drop table orders;

--import data from book csv
copy book(Book_ID,Title,Author,Genre,Published_year,Price,stock)
from 'C:\Users\pranay\Desktop\SQL Project_Data\Books.csv'
csv header;

--import data from customer csv
copy customer(Customer_ID,Name,Email,Phone,City,Country)
from 'C:\Users\pranay\Desktop\SQL Project_Data\Customers.csv'
csv header;

--import data from orders csv
copy orders(Order_ID,Customer_ID,Book_ID,Order_Date,Quantity,Total_Amount)
from 'C:\Users\pranay\Desktop\SQL Project_Data\Orders.csv'
csv header;

select * from book;
select * from customer;
select * from orders;

--1  Retrive all books in the 'Fiction' genre:
select * from book where genre ='Fiction';

--2  Find Books published after the year 1950:
select * from book where published_year>1950;

--3 List all customers from the canada:
select * from customer where country='Canada';

--4 Show orders placed in november 2023:
select * from orders where order_date between '2023-11-01' and '2023-11-30';

--5 Retrive the total stock of books available:
select sum(stock) from book;

--6 Find the details of the most expensive book:
select * from book order by price desc limit 1;

--7 Show all customers who ordered more than 1 quantity of a book:
select * from orders where quantity>1;

--8 Retrive all orders where the total amount exceeds $20:
select * from orders where total_amount>20;

--9 List all genres available in the books table:
select distinct genre from book;

--10 Find the book with the lowest stock:
select * from book order by stock asc limit 1;

--11 Calculate the total revenue generated from all orders:
select sum(total_amount) from orders;

--12 Retrieve the total number of books sold for each genre:
select distinct b.genre,sum(o.quantity) as Total_n_books from book b join orders o on b.book_id=o.book_id 
group by b.genre;

--13 Find the average price of books in the "Fantasy" genre:
select genre,avg(price) as avg_price from book where genre= 'Fantasy'
group by genre;

--14 List customers who have placed at least 2 orders:
select o.customer_id,c.name,count(o.order_id) from customer c join orders o on c.customer_id=o.customer_id
group by o.customer_id,c.name having count(o.order_id)>=2;

--15 Find the most frequently ordered book:
select o.book_id,b.title,count(o.order_id) as order_count from orders o join book b on b.book_id=o.book_id
group by o.book_id,b.title order by order_count desc limit 1;

--16 show the top 3 most expensive books of 'Fantasy game':
select title,genre,price from book order by price desc limit 3;

--17 Retrieve the total quantity of books sold by each author:
select b.author,sum(o.quantity) from book b join orders o on b.book_id=o.book_id group by b.author;

--18 List the cities where customers who spent over $30 are located:
select distinct c.city,o.total_amount from customer c join orders o on c.customer_id=o.customer_id
where o.total_amount>30;

--19 Find the customer who spent the most on orders:
select c.name,sum(o.total_amount) from customer c join orders o on c.customer_id=o.customer_id
group by c.name order by sum(o.total_amount) desc limit 1;

--20 Calculate the stock remaining after fulfilling all orders:
select b.title,b.book_id,b.stock,coalesce(sum(o.quantity),0) as order_quantity,b.stock-coalesce(sum(o.quantity),0) as remain_stock 
from book b left join orders o on o.book_id=b.book_id
group by b.title,b.stock,b.book_id order by b.book_id asc;













