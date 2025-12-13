"""CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(250) NOT NULL UNIQUE,
    password VARCHAR(250) NOT NULL
);

CREATE TABLE todos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    content VARCHAR(100),
    due DATETIME,
    FOREIGN KEY (user_id) REFERENCES users(id)
);
"""

Drop Table Equip; 
Drop Table Enemies; 
Drop Table Biomes;
Drop Table Player; 
Drop Table Player_mutations; 
Drop Table Status_effects; 
Drop Table Cosmetics;
Drop Table Enemy_Biome; 

Create Table Equip (
    item_name varchar(100) Primary Key Not Null,
    dmgtype varchar(100) Not Null,
    dmgnumber int(100000) Not Null,
    item_grade varchar(100) Not Null,
    item_info varchar(100) Not Null,
    atk_speed int(1000) Not Null,
    atk_range int(1000) Not Null,
    crit_dmg_conditions varchar(100),
    attributes varchar(100),
    item_effect varchar(100),
    item_cooldown int(1000),
    FOREIGN KEY (username) REFERENCES Player(username) --1:n relation between player and equipment -> add foreign key in n Table
);

create Table Enemies (
    enemy_name varchar(100) Primary Key,
    enemyhealth int(1000000) Not Null,
    enemy_resist varchar(100),
    dmg_type varchar(100) Not Null,
    dmg_effect varchar(100),
    dmg_number int(10000) Not Null
);

create Table Biomes (
    biome_name varchar(100) Primary Key,
    biome_info varchar(100) Not Null,
    biome_status_effect varchar(100),
    biome_map varchar(100) Not Null,
    biome_requirements varchar(100) Not Null,
    biome_gimmick varchar(100)
);

create Table Player (
    username varchar(100) Primary Key,
    status_effects varchar(100),
    cosmetics varchar(100),
    FOREIGN KEY (skin_name) REFERENCES Cosmetics(Skin_name),
    FOREIGN KEY (biome_name) REFERENCES Biomes(biome_name)
);

create Table Player_mutations (
    name varchar(100) Primary Key,
    mutation_effect varchar(100),
    cost int(100),
    mutation_type varchar(100),
    FOREIGN KEY (username) REFERENCES Player(username) --1:n relation between player and player_mutation -> add foreign key in n Table
);

create Table Status_effects (
    effect_name varchar(100) Primary Key,
    effect_info varchar(100),
    FOREIGN KEY (username) REFERENCES Player(username) --1:n relation between player and status_effects -> add foreign key in n Table
);

create Table Cosmetics (
    skin_name varchar(100) Primary Key,
    skin_description varchar(100),
    unlock_condition varchar(100)
);

CREATE TABLE Enemy_Biome (
    enemy_name VARCHAR(100),
    biome_name VARCHAR(100),
    PRIMARY KEY (enemy_name, biome_name), -- Composite primary key to prevent duplicates
    FOREIGN KEY (enemy_name) REFERENCES Enemies(enemy_name)-- Foreign keys to maintain referential integrity
        ON DELETE CASCADE --Causes table to automatically update or delete if the original tables get changed
        ON UPDATE CASCADE,
    FOREIGN KEY (biome_name) REFERENCES Biomes(biome_name)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

--insert sample data 
Insert Into Equip(item_name, dmgtype, dmgnumber, item_grade, item_info, atk_speed, atk_range, crit_dmg_conditions, attributes, item_effect, item-cooldown) Values
(),
(),
();

Insert Into Enemies(enemy_name, enemyhealth, enemy_resist, dmg_type, dmg_effect, dmg_number) Values
(),
(),
();

Insert Into Biomes(biome_name, biome_info, biome_status_effect, biome_map, biome_requirements, biome_gimmick) Values
(),
(),
();

Insert Into Player(username, status_effects, cosmetics) Values
(),
(),
();

Insert Into Player_mutations(name, mutation_effect, cost, mutation_type) Values
(),
(),
();

Insert Into Status_effects(effect_name, effect_info) Values
(),
(),
();

Insert Into Cosmetics(skin_name, skin_description, unlock_condition) Values
(),
(),
();
