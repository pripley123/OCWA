db.createUser(
    {
        user: "$MONGO_USERNAME",
        pwd: "$MONGO_PASSWORD",
        roles: [ "readWrite" ]
    }
);

