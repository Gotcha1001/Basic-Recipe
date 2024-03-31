import express from "express";
import bodyParser from "body-parser";
import pg from "pg";
import env from "dotenv";

const app = express();
const port = 3000;

env.config();
app.set("view engine", "ejs"); // Set the view engine to EJS

const db = new pg.Client({
    user: process.env.PG_USER,
    host: process.env.PG_HOST,
    database: process.env.PG_DATABASE,
    password: process.env.PG_PASSWORD,
    port: process.env.PG_PORT
});

db.connect();

app.use(bodyParser.urlencoded({ extended: true }));
app.use(express.static("public"));

app.get("/", async (req, res) => {
    try {
        const userId = req.query.userId;
        const usersResult = await db.query("SELECT * FROM users");
        const users = usersResult.rows;

        let recipesResult;
        let recipes;
        if (userId) {
            recipesResult = await db.query("SELECT recipes.*, users.username AS user_name FROM recipes JOIN users ON recipes.user_id = users.id WHERE users.id = $1 ORDER BY recipes.id ASC", [userId]);
            recipes = recipesResult.rows;
        } else {
            recipesResult = await db.query("SELECT recipes.*, users.username AS user_name FROM recipes JOIN users ON recipes.user_id = users.id ORDER BY recipes.id ASC");
            recipes = recipesResult.rows;
        }

        res.render("index.ejs", { recipes: recipes, users: users, user: users[0] });
    } catch (error) {
        console.error("Error fetching data:", error);
        res.status(500).send("Error fetching data");
    }
});

// Route for the Create page 
app.get("/create", (req, res) => {
    res.render("create.ejs");
});

// Create a Recipe to post
app.post("/add", async (req, res) => {
    try {
        const { title, image_url, ingredients, recipe } = req.body;
        const userId = 1; // Assuming a default user ID of 1

        await db.query("INSERT INTO recipes (user_id, title, image_url, ingredients, recipe) VALUES ($1, $2, $3, $4, $5)", [userId, title, image_url, ingredients, recipe]);
        res.redirect("/");
    } catch (error) {
        console.error("Error adding recipe:", error);
        res.status(500).send("Error adding recipe");
    }
});

// Route for the Modify page
app.get("/modify/:id", async (req, res) => {
    const recipeId = req.params.id;
    try {
        const result = await db.query("SELECT * FROM recipes WHERE id = $1", [recipeId]);
        const recipe = result.rows[0];
        res.render("modify.ejs", { recipe: recipe });
    } catch (error) {
        console.log(error);
        res.status(500).send("Error retrieving recipe data");
    }
});

// POST route for modifying a recipe
app.post("/modify/:id", async (req, res) => {
    const recipeId = req.params.id;
    const { title, image_url, ingredients, recipe } = req.body;
    try {
        await db.query("UPDATE recipes SET title = $1, image_url = $2, ingredients = $3, recipe = $4 WHERE id = $5",
            [title, image_url, ingredients, recipe, recipeId]);
        res.redirect("/");
    } catch (error) {
        console.error(error);
        res.status(500).send("Error updating recipe");
    }
});

// DELETE a recipe using the id
app.post("/delete", async (req, res) => {
    const id = req.body.deleteItemId;
    try {
        await db.query("DELETE FROM recipes WHERE id = $1", [id]);
        res.redirect("/");
    } catch (error) {
        console.error(error);
    }
});

// Add a route for creating a new user
app.post("/users", async (req, res) => {
    try {
        const { username } = req.body;
        const newUser = await db.query("INSERT INTO users (username) VALUES ($1) RETURNING id, username", [username]);
        res.redirect("/"); // Redirect to the home page
    } catch (error) {
        console.error("Error creating user:", error);
        res.status(500).send("Error creating user");
    }
});

app.listen(port, () => {
    console.log(`Server running on port ${port}`);
});



  /*

Here's a basic example of how you could add a route for creating a new user and updating the user displayed in the button:

Add a route for creating a new user:


app.post("/users", async (req, res) => {
    try {
        const { username } = req.body;
        const newUser = await db.query("INSERT INTO users (username) VALUES ($1) RETURNING id, username", [username]);
        res.status(201).json(newUser.rows[0]);
    } catch (error) {
        console.error("Error creating user:", error);
        res.status(500).send("Error creating user");
    }
});

Update your index route to fetch all users and pass them to your template:

app.get("/", async (req, res) => {
    try {
        const users = await db.query("SELECT * FROM users");
        res.render("index.ejs", { users: users.rows });
    } catch (error) {
        console.error("Error fetching users:", error);
        res.status(500).send("Error fetching users");
    }
});



Update your index.ejs template to include a form for creating a new user and buttons for each user:

<% users.forEach(user => { %>
    <button class="btn btn-primary my-4" onclick="changeUser('<%= user.id %>')"><%= user.username %></button>
<% }) %>

<form action="/users" method="post">
    <input type="text" name="username" placeholder="Enter username" required>
    <button type="submit" class="btn btn-primary">Create User</button>
</form>

<script>
    function changeUser(userId) {
        // You can implement logic here to change the user displayed in the button
        console.log("Changing user to:", userId);
    }
</script>


Implement the changeUser function in the script tag to update the recipes displayed based on the selected user. This would involve fetching recipes for the selected user and updating the recipes displayed on the page.
Note: This is a basic example and may require additional error handling and validation based on your specific requirements and environment.

  */