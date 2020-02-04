const express = require("express"),
  router = express.Router(),
  path = require("path"),
  rootDir = require("../util/path"),
  usersDB = require("../util/users"),
  bcrypt = require("bcryptjs");

router.get("/signup", (req, res, next) => {
  return res.sendFile(path.join(rootDir, "views", "signup.html"));
});

router.post("/signup", function(request, response) {
  let username = request.body.username;
  let password = request.body.password;
  let confirm = request.body.confirm;
  if (confirm !== password) {
    response.status(400).render("error", {
      docTitle: "400 page",
      message: "Password and confirm password must match"
    });
  }
  if (username && password) {
    usersDB
      .getByEmail(username)
      .then(result => {
        if (result[0].length > 0) {
          console.log(`${username} already exist the database`);
          response.status(401).render("error", {
            docTitle: "401 page",
            message: "User already exist. Choose another email address please."
          });
        } else {
          // hash the password
          bcrypt
            .hash(password, 12)
            .then(function(hash) {
              // Store hash in your password DB.
              console.log(
                `creating a new user : ${username} with a hash ${hash}`
              );
              return usersDB.createUser(username, hash);
            })
            .then(() => response.redirect("/login"));
        }
      })
      .catch(err => console.log(err));
  } else {
    console.log("Not authorized");
    response.status(400).render("error", {
      docTitle: "400 page",
      message: "Username and password are required "
    });
  }
});

module.exports = router;
