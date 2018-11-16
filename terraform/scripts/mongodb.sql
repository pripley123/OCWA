use oc_db

db.createUser(
    {
        user: "userX",
        pwd: "passwordX",
        roles: [ "readWrite" ]
    }
)
