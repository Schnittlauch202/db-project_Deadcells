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
Create Table Equip (
    item_name varchar(100) Primary Key,
    dmgtype varchar(100),
    dmgnumber int(100000),
    item_grade varchar(100),
    item_info varchar(100),
    atk_speed int(1000),
    atk_range int(1000),
    crit_dmg_conditions varchar(100),
    attributes varchar(100),
    item_effect varchar(100),
    item_cooldown int(1000)
);

create Table Enemies (
    enemy_name varchar(100) Primary Key,
    enemyhealth int(1000000),
    enemy_resist varchar(100),
    dmg_type varchar(100),
    dmg_effect varchar(100),
    dmg_number int(10000)
);

create Table Biomes (
    biome_name varchar(100) Primary Key,
    biome_info varchar(100),
    biome_enemies, varchar(100),
    biome_status_effect varchar(100),
    biome_map varchar(100),
    biome_requirements varchar(100),
    biome_gimmick varchar(100)
);

create Table Player (
    username varchar(100) Primary Key,
    status_effects varchar(100),
    cosmetics varchar(100)
);

create Table Player_mutations (
    name varchar(100) Primary Key,
    mutation_effect varchar(100),
    cost int(100),
    mutation_type varchar(100)
);

create Table Status_effects (
    effect_name varchar(100) Primary Key,
    effect_info varchar(100)
);

create Table Cosmetics (
    skin_name varchar(100) Primary Key,
    skin_description varchar(100),
    unlock_condition varchar(100)
);