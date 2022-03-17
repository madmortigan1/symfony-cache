# symfony-cache

A basic app to show PHP not catching exption of "include <file>" command.
The exception is cought multiple times and then stops and the php crashes without any error or indication.

The issue is in the following file: 
  ``` vendors\Symfony\Component\Cache\Adapter\PhpFilesAdapter  ```
  
  on line 143: ```} elseif (\is_array($expiresAt = include $file)) {```

![image](https://user-images.githubusercontent.com/53225926/158756826-92d96f82-3637-480a-8d58-a3c930c11499.png)


There is a set_error_handler set to throw \ErrorException which catches the error when a file does not exists.
But after multiple times it does not catch it and PHP crashes.


<h1>Installation</h1>
After getting the app, run ```composer install``` to update the vendors directory.

There is a need to create a database named sym6 (otherwise change the name in .env)
  
The docker contains a container for POSTGRES database which is listning on ```localhost:5437```
  
Username and password are inside docker-compose.override.yaml in root directory.
  
You could also use any other database you have, just map an entity to it
and run the following lines to create the table and add data:


  

```
drop table if exists sym6.settings;
create table sym6.settings (
  id serial not null,
  data text,
  primary key (id)
)
with (
  oids = false
);

alter table sym6.settings
  owner to sym6;

insert into settings ("data")
values ('test1'), ('test2')
```

