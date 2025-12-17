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
    biome_status_effect varchar(100),
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
Insert Into Equip(item_name, dmgtype, dps, item_info, atk_speed, atk_range, crit_dmg_conditions, attributes, item_effect, item-cooldown) Values
('Twin Daggers', 'Melee Weapon', 173, 'the Twin Daggers are a sword-type melee weapon which deal a critical hit on the third strike of each combo', 1.07, 'close quarters', 'Always deals a high-damage critical hit on the third hit of each combo', , 'Increases your movement speed for 5 seconds after a critical hit', ,),
('BroadSword', 'Melee Weapon', 176, 'The Broadsword is a heavy melee weapon which swings slowly, but deals critical damage during subsequent attacks in its combo', 2.25, 'close quarters, third hit has slightly longer range than the previous two', 'The second and third hits will always deal a critical hit', , 'if legendary grade grants a shield upon killing an enemy', ,),
('Laser Glaive', 'ranged weapon', 70, 'The Laser Glaive is a ranged weapon that is focused on dealing with multiple enemies', 1.2, 'deals crit damage after two bounces', , 'The projectile can bounce up to 6 times, Each additional hit after the first crit increases the projectile speed by 10% and its damage by 25%', 0.8);

Insert Into Enemies(enemy_name, enemyhealth, enemy_resist, dmg_type, dmg_effect, dmg_number, moveset) Values
('Scorpion', 100, , 'melee, projectile', 'poison', , 'Tail swipe, venom shot'),
('The Concierge', 4000, , 'ranged, AOE, melee', 'stun with "shout" attack', , 'attack: stab, firestrike, leap,defence: shout, Aura of laceration'),
('Ground Shaker', 300, 'immune to stun, cannot be harmed from the back', 'melee, ranged, AOE', 'ranged and AOE cannot be parried or dodge rolled', , 'Avalanche, swipe combo, ');

Insert Into Biomes(biome_name, biome_status_effect, biome_requirements, biome_gimmick) Values
('Prisoners Quarters', 'none', 'none', 'none'),
('Forgotten Sepulcher', 'darkness', 'teleportation runem', 'spikes'),
('Undying Shores', 'none', 'cultist outfit', 'none');

Insert Into Player(username, cosmetics) Values
(, 'Cultist Outfit'), 
(, 'Festive Outfit'),
(, 'Galaxy Outfit');


Insert Into Player_mutations(name, mutation_effect, cost, mutation_type) Values
('Predator', 'invisibility', 'killing an enemy with melee strike', 'brutality'),
('Point Blank', 'attacks inflicts +30% bonus damage', 'close-ranged attack with ranged weapon', 'tactics'),
('What doesnt kill me', 'recover 2% of max HP', 'parrying a melee attack', 'survival');

Insert Into Status_effects(effect_name, effect_info) Values
('Bleed', 'Bleed effects cause enemies to take large amounts of damage over the course of their duration. If 5 bleed effects are inflicted upon an enemy, all of the damage they would have inflicted over the course of their duration is dealt all at once in a sudden burst of blood. Enemies that are bleeding will be visibly squirting blood.'),
('Slow', 'Slow reduces enemy movement and attack speed to around half of what it would normally be, making enemies easier to engage as they will not be able to attack as quickly.'),
('Damage Resistance', 'Damage resistance reduces the damage of incoming hits by a percentage. It is most commonly used by the player, as multiple skills, affixes, and mutations will grant this buff to the player.');

Insert Into Cosmetics(skin_name, skin_description, unlock_condition) Values
('Cultist Outfit', 'Do you have a minute to talk about our Lord and Saviour?', 'Drops from any of the corpses scattered inside the large floating islands of Fractured Shrines; can be instantly equipped with the Homunculus Rune'),
('Flawless Concierge Outfit', 'Garb sported by the lowliest of achievers...', 'Defeat the Concierge without taking damage'),
('Golden Outfit', 'You definitely wont go unnoticed wearing this.', 'Specialist Shop in the Prisoners Quarters; costs 10,000 gold or a 50-kill curse');