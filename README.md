# Tailored Project Description

Created by Susan Huang, Maya Prasad, Hamsa Madhira, and Anh Nguyen for CS3200 - Database Design.

## What is Tailored?
Currently, whilst shopping for clothing or accessories, people run into the issue of too many choices, many of which are not personalized to their preferences. Our product, Tailored, minimizes this indecisiveness when shopping. Acting as a blend of Google and Pinterest, Tailored will allow users to bring their fashion vision board to reality. The app will take in input information relating to their stylistic choices and demographics such as age, gender, preferred color palettes, textures, purpose of purchase, price range, gender, and urgency. From this user information, the app will select from multiple databases, the appropriate clothing options for the user, and display outfits with links to the specific pieces. This personalized method of shopping allows users to streamline their decisions.

## This repo contains a boilerplate setup for spinning up 3 Docker containers:
1. A MySQL 8 container
2. A Python Flask container to implement a REST API
3. A Local AppSmith Server

## Getting started
1. Clone this repository
2. Create a file named `db_root_password.txt` in the `secrets/` folder and enter your root password for MySQL.
3. Create a file neamed `db_password.txt` in the `secrets/` folder and enter the password for a non-root user.
4. In your terminal or command prompt, navigate to the `docker_compose.yml` file.
5. Build the images in Docker using this command: `docker compose build`.
6. Start the containers with `docker compose up`. To run in detached mode, use `docker compose up -d`. There should be three containers: web, db, and appsmith in Docker.

## Video Demo
Youtube
https://www.youtube.com/watch?v=ZWc_p2daGSY

Google Drive
https://drive.google.com/drive/folders/14MPJqtjr8m360rwZPe-AgV_-GJO1mb_7?usp=sharing

(At 04:38, when we clicked on the `Add to Wishlist` button for Item 3, the "Item Successfully Added" message didn't pop up but the Item was added to the wishlist. This bug has been fixed and the message should pop up for all `Add to Wishlist` button.)
 




