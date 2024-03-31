RECIPE app

Food App

Database name = recipe

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE
);


CREATE TABLE recipes (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(id),
    title VARCHAR(100),
    image_url VARCHAR(255),
    recipe TEXT
);






1.	Initialize Your Node.js Project:
npm init 

2.	Install Required Packages:
npm install express pg axios ejs 


- then in package.json add below ... "main"
"type": "module",

Here's what each package is for:
•	express: Web framework for Node.js.
•	pg: PostgreSQL client for Node.js.
•	axios: Promise-based HTTP client for making API requests.
•	ejs: Templating engine for rendering views.

BASIC SETUP OBVIOIUSLY CHANGE YOUR DATABASE NAME
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
import express from "express";
import bodyParser from "body-parser";
import pg from "pg";

const app = express();
const port = 3000;

app.set("view engine", "ejs"); // Set the view engine to EJS

const db = new pg.Client({
  user: "postgres",
  host: "localhost",
  database: "permalist",
  password: "Axelrose747",
  port: 5432,
});

db.connect();

app.use(bodyParser.urlencoded({ extended: true }));
app.use(express.static("public"));

app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});

xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

6.	Set Up Your PostgreSQL Database Connection in the db directory. JUST AN EXAMPLE

import express from "express";
import bodyParser from "body-parser";
import pg from "pg";

const app = express();
const port = 3000;

app.set("view engine", "ejs"); // Set the view engine to EJS

const db = new pg.Client({
user: "postgres",
host: "localhost",
database: "bookreview",
password: "Axelrose747",
port: 5432,
});

db.connect();

app.use(bodyParser.urlencoded({ extended: true }));
app.use(express.static("public"));

let books = [
{ id: 1, title: "Book 1", author: "Author 1", isbn: "1234567890", coverUrl: "https://example.com/book1.jpg", summary: "Summary of Book 1", notes: "Notes for Book 1", rating: 4, dateRead: "2024-04-01" },
{ id: 2, title: "Book 2", author: "Author 2", isbn: "0987654321", coverUrl: "https://example.com/book2.jpg", summary: "Summary of Book 2", notes: "Notes for Book 2", rating: 3, dateRead: "2024-04-02" },
];

let users = [
{ id: 1, username: "user1" },
{ id: 2, username: "user2" },
];

app.get("/", async (req, res) => {
try {
const booksResult = await db.query("SELECT * FROM books ORDER BY id ASC");
const books = booksResult.rows;

const usersResult = await db.query("SELECT * FROM users ORDER BY id ASC");
const users = usersResult.rows;

res.render("index.ejs", {
books: books,
users: users,
});
} catch (err) {
console.log(err);
}
});


app.post("/add", async (req, res) => {
const { title, author, isbn, coverUrl, summary, notes, rating, dateRead } = req.body;
try {
await db.query("INSERT INTO books (title, author, isbn, cover_url, summary, notes, rating, date_read) VALUES ($1, $2, $3, $4, $5, $6, $7, $8)", [title, author, isbn, coverUrl, summary, notes, rating, dateRead]);
res.redirect("/");
} catch (err) {
console.log(err);
}
});

app.post("/delete", async (req, res) => {
const id = req.body.deleteItemId;
try {
await db.query("DELETE FROM books WHERE id = $1", [id]);
res.redirect("/");
} catch (err) {
console.log(err);
}
});	

app.listen(port, () => {
console.log(`Server running on port ${port}`);
});

XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
7. This is just an idea the routes dont use them...... but setting up the database yes....
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
8. create the DATABASE

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR
);

CREATE TABLE books (
	id SERIAL PRIMARY KEY,
	title VARCHAR,
	author VARCHAR,
	ISBN VARCHAR,
	coverURL VARCHAR,
	summary TEXT,
	notes TEXT,
	rating INTEGER,
	dateRead DATE,
	users_id INTEGER REFERENCES users(id) ON DELETE CASCADE
);

9. INSERTING DATA 

INSERT INTO users (username)
VALUES ('John Press');

INSERT INTO books (title, author, ISBN, coverURL, summary, notes, rating, dateRead, users_id)
VALUES ('Charlie and the Chocolate Factory', 'Roald Dahl', '0141365374', 'https://covers.openlibrary.org/b/isbn/0141365374-L.jpg', 'This book is a great novel', 'This book reminds me of when I was a child and the story of winning it lucky and having a pure heart gets you places', 10, '2024-04-01', 1);

10. Join tables 

SELECT * 
FROM users
JOIN books
ON users.id = users_id


XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

13. example of use AXIOS to consume a 3rd party API

app.get("/book/:isbn/cover", async (req, res) => {
  const { isbn } = req.params;
  try {
    const response = await axios.get(`https://covers.openlibrary.org/b/isbn/${isbn}-L.jpg`);
    res.send(response.data);
  } catch (error) {
    console.error(error);
    res.status(500).send("Error fetching book cover");
  }
});


14. example of a index.ejs to display books

xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
EXAMPLES TO WORK WITH FROM THE CAPSTONE PROJECT 

index.ejs

xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

<%- include('partials/header.ejs'); -%>

<body class="gradient-background2">
  <div class="container">
    <h1 class="text-center my-4">Book Reviews</h1>
    <!-- Button to create a new review -->
    <button onclick="toggleForm()" class="btn btn-primary mb-4">Create Review</button>
    <!-- Form for adding a new book -->
    <div id="newBookForm" style="display: none;">
      <h2>Add a New Book</h2>
      <form action="/add" method="post">
        <div class="mb-3">
          <label for="title" class="form-label">Title:</label>
          <input type="text" class="form-control" id="title" name="title" required>
        </div>
        <div class="mb-3">
          <label for="author" class="form-label">Author:</label>
          <input type="text" class="form-control" id="author" name="author" required>
        </div>
        <div class="mb-3">
          <label for="isbn" class="form-label">ISBN:</label>
          <input type="text" class="form-control" id="isbn" name="isbn" required>
        </div>
        <!-- Add a hidden input field for the coverUrl -->
        <input type="hidden" id="coverUrl" name="coverUrl">
        <div class="mb-3">
          <label for="summary" class="form-label">Summary:</label>
          <textarea class="form-control" id="summary" name="summary" required></textarea>
        </div>
        <div class="mb-3">
          <label for="notes" class="form-label">Notes:</label>
          <textarea class="form-control" id="notes" name="notes" required></textarea>
        </div>
        <div class="mb-3">
          <label for="rating" class="form-label">Rating:</label>
          <input type="number" class="form-control" id="rating" name="rating" min="0" max="10" required>
        </div>
        <div class="mb-3">
          <label for="dateRead" class="form-label">Date Read:</label>
          <input type="date" class="form-control" id="dateRead" name="dateRead" required>
        </div>
        <button type="submit" class="btn btn-primary">Add Book</button>
      </form>
    </div>
    <div class="row">
      <% books.forEach(book => { %>
        <div class="col-md-4 mb-4">
          <div class="card h-100">
            <img src="<%= book.coverUrl %>" class="card-img-top" alt="<%= book.title %>">
            <div class="card-body">
              <h5 class="card-title"><%= book.title %></h5>
              <p class="card-text">Author: <%= book.author %></p>
              <p class="card-text">Summary: <%= book.summary %></p>
              <p class="card-text">Notes: <%= book.notes %></p>
              <p class="card-text">Rating: <%= book.rating %>/10</p>
              <p class="card-text">Date Read: <%= book.dateRead %></p>
              <!-- Button to modify the review -->
              <form action="/modify/<%= book.id %>" method="get">
                <button type="submit" class="btn btn-primary">Modify</button>
              </form>
              <!-- Form for deleting the review -->
              <form action="/delete" method="post">
                <input type="hidden" name="deleteItemId" value="<%= book.id %>">
                <button style="margin-top: 10px;" type="submit" class="btn btn-danger">Delete</button>
              </form>
            </div>
          </div>
        </div>
      <% }); %>
    </div>
  </div>

  <%- include('partials/footer.ejs'); -%>
  
  <script>
    function toggleForm() {
      var form = document.getElementById("newBookForm");
      form.style.display = form.style.display === "none" ? "block" : "none";
    }
  </script>

</body>
</html>


partials 

FOOTER  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

</main>
<footer>Copyright © <%= new Date().getFullYear() %>
</footer>
</body>

</html>

HEADER xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="UTF-8" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha2/dist/css/bootstrap.min.css" rel="stylesheet"
  integrity="sha384-aFq/bzH65dt+w6FI2ooMVUpc+21e0SRygnTpmBvdBgSdnuTN7QbdgL+OapgHtvPp" crossorigin="anonymous">
  <link rel="stylesheet" href="styles/main.css" />
  <title>Permalist</title>
</head>

<body>
  <main>
 
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
MODIFY .ejs

<%- include('partials/header.ejs'); -%>

<body class="gradient-background2">
  <div class="container">
    <h1 class="mt-5">Modify Book Review</h1>
    <form action="/modify/<%= book.id %>" method="post">
      <div class="mb-3">
        <label for="title" class="form-label">Title:</label>
        <input type="text" id="title" name="title" value="<%= book.title %>" class="form-control" required>
      </div>
      <div class="mb-3">
        <label for="author" class="form-label">Author:</label>
        <input type="text" id="author" name="author" value="<%= book.author %>" class="form-control" required>
      </div>
      <div class="mb-3">
        <label for="isbn" class="form-label">ISBN:</label>
        <input type="text" id="isbn" name="isbn" value="<%= book.isbn %>" class="form-control" required>
      </div>
      <!-- Add a hidden input field for the coverUrl -->
      <input type="hidden" id="coverUrl" name="coverUrl" value="<%= book.coverUrl %>">
      <div class="mb-3">
        <label for="summary" class="form-label">Summary:</label>
        <textarea id="summary" name="summary" class="form-control" required><%= book.summary %></textarea>
      </div>
      <div class="mb-3">
        <label for="notes" class="form-label">Notes:</label>
        <textarea id="notes" name="notes" class="form-control" required><%= book.notes %></textarea>
      </div>
      <div class="mb-3">
        <label for="rating" class="form-label">Rating:</label>
        <input type="number" id="rating" name="rating" min="0" max="10" value="<%= book.rating %>" class="form-control" required>
      </div>
      <div class="mb-3">
        <label for="dateRead" class="form-label">Date Read:</label>
        <input type="date" id="dateRead" name="dateRead" value="<%= book.dateRead %>" class="form-control" required>
      </div>
      <button type="submit" class="btn btn-primary">Submit Changes</button>
    </form>
  </div>
</body>

<%- include('partials/footer.ejs'); -%>

</html>

xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
index.js

import express from "express";
import bodyParser from "body-parser";
import pg from "pg";
import axios from "axios"; 

const app = express();
const port = 3000;

app.set("view engine", "ejs"); // Set the view engine to EJS

const db = new pg.Client({
  user: "postgres",
  host: "localhost",
  database: "bookreview",
  password: "Axelrose747",
  port: 5432,
});

db.connect();

app.use(bodyParser.urlencoded({ extended: true }));
app.use(express.static("public"));


let books = [
    { id: 1, title: "Book 1", author: "Author 1", isbn: "1234567890", coverUrl: "https://example.com/book1.jpg", summary: "Summary of Book 1", notes: "Notes for Book 1", rating: 4, dateRead: "2024-04-01" },
    { id: 2, title: "Book 2", author: "Author 2", isbn: "0987654321", coverUrl: "https://example.com/book2.jpg", summary: "Summary of Book 2", notes: "Notes for Book 2", rating: 3, dateRead: "2024-04-02" },
  ];

  let users = [
    { id: 1, username: "user1" },
    { id: 2, username: "user2" },
  ];
  
  
  
  app.get("/", async (req, res) => {
    try {
      const booksResult = await db.query("SELECT * FROM books ORDER BY id ASC");
      const books = booksResult.rows;
  
      // Fetch cover URLs for each book
      for (const book of books) {
        try {
          const response = await axios.get(`https://covers.openlibrary.org/b/isbn/${book.isbn}-L.jpg`);
          book.coverUrl = response.request.res.responseUrl; // update the coverUrl property
        } catch (error) {
          console.error(error);
          // Handle error (e.g., set a default cover image)
          book.coverUrl = "default-cover.jpg";
        }
      }
  
      res.render("index.ejs", {
        books: books,
      });
    } catch (err) {
      console.log(err);
    }
  });

  //route for a new user
  app.get("/user/:id", async (req, res) => {
    const userId = req.params.id;
    try {
      const userResult = await db.query("SELECT * FROM users WHERE id = $1", [userId]);
      const user = userResult.rows[0];
      
      const booksResult = await db.query("SELECT * FROM books WHERE users_id = $1 ORDER BY id ASC", [userId]);
      const books = booksResult.rows;
  
      res.render("user.ejs", {
        username: user.username,
        books: books
      });
    } catch (err) {
      console.log(err);
      res.status(500).send("Error retrieving user data");
    }
  });
  

  //new users route to add a book with id 
  app.post("/addReview", async (req, res) => {
    const { title, author, isbn, summary, notes, rating, dateRead, coverUrl } = req.body;
    try {
      await db.query("INSERT INTO books (title, author, isbn, summary, notes, rating, dateread, coverURL, users_id) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)",
        [title, author, isbn, summary, notes, rating, dateRead, coverUrl, req.params.id]); // Assuming req.params.id contains the user ID
      res.redirect(`/user/${req.params.id}`);
    } catch (err) {
      console.error(err);
      res.status(500).send("Error adding book review");
    }
  });
  
  
  app.post("/add", async (req, res) => {
  const { title, author, isbn, summary, notes, rating, dateRead, coverUrl } = req.body;
  try {
    await db.query("INSERT INTO books (title, author, isbn, summary, notes, rating, dateread, coverURL) VALUES ($1, $2, $3, $4, $5, $6, $7, $8)",
      [title, author, isbn, summary, notes, rating, dateRead, coverUrl]);
    res.redirect("/");
  } catch (err) {
    console.error(err);
    res.status(500).send("Error adding book");
  }
});

app.post("/addUser", async (req, res) => {
  const { username } = req.body;
  try {
    const result = await db.query("INSERT INTO users (username) VALUES ($1) RETURNING id", [username]);
    const userId = result.rows[0].id;
    res.redirect(`/user/${userId}`);
  } catch (err) {
    console.error(err);
    res.status(500).send("Error adding user");
  }
});

  
  app.post("/delete", async (req, res) => {
    const id = req.body.deleteItemId;
    try {
      await db.query("DELETE FROM books WHERE id = $1", [id]);
      res.redirect("/");
    } catch (err) {
      console.log(err);
    }
  });

// GET route for displaying the form to modify a book review
app.get("/modify/:id", async (req, res) => {
  const bookId = req.params.id;
  try {
    const result = await db.query("SELECT * FROM books WHERE id = $1", [bookId]);
    console.log("Result:", result.rows); // Log the fetched data
    const book = result.rows[0];
    res.render("modify.ejs", { book: book });
  } catch (err) {
    console.error(err);
    res.status(500).send("Error retrieving book data");
  }
});



// POST route for modifying a book review
app.post("/modify/:id", async (req, res) => {
  const bookId = req.params.id;
  const { title, author, isbn, summary, notes, rating, dateRead, coverUrl } = req.body;
  try {
    await db.query("UPDATE books SET title = $1, author = $2, isbn = $3, summary = $4, notes = $5, rating = $6, dateread = $7, coverURL = $8 WHERE id = $9",
      [title, author, isbn, summary, notes, rating, dateRead, coverUrl, bookId]);
    res.redirect(`/`);
  } catch (err) {
    console.error(err);
    res.status(500).send("Error updating book review");
  }
});


app.listen(port, () => {
    console.log(`Server running on port ${port}`);
  });
