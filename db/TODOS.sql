Drop Table Equip; 
Drop Table Enemies; 
Drop Table Biomes;
Drop Table Player; 
Drop Table Player_mutations; 
Drop Table Status_effects; 
Drop Table Cosmetics;
Drop Table Enemy_Biome; 


create Table Cosmetics (
    skin_name varchar(100) Primary Key,
    skin_description varchar(100),
    unlock_condition varchar(255)
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
    skin_name varchar(100),
    biome_name varchar(100), 
    FOREIGN KEY (skin_name) REFERENCES Cosmetics(Skin_name),
    FOREIGN KEY (biome_name) REFERENCES Biomes(biome_name)
);

Create Table Equip (
    item_name varchar(100) Primary Key Not Null,
    dmgtype varchar(100) Not Null,
    dps int(255) Not null,
    item_grade varchar(100),
    item_info Text Not Null,
    atk_speed int(255) Not Null,
    atk_range varchar(255),
    crit_dmg_conditions varchar(100),
    attributes varchar(100),
    item_effect Text,
    item_cooldown int(255),
    username varchar(100) Not Null,
    FOREIGN KEY (username) REFERENCES Player(username)
);

create Table Enemies (
    enemy_name varchar(100) Primary Key,
    enemyhealth int(255) Not Null,
    enemy_resist varchar(100),
    dmg_type varchar(100) Not Null,
    dmg_effect varchar(100),
    dmg_number int(255),
  	moveset varchar(100) not null
);


create Table Player_mutations (
    mutation_name varchar(100) Primary Key,
    mutation_effect varchar(100),
    cost varchar(100),
    mutation_type varchar(100),
    username varchar(100) Not Null, 
    FOREIGN KEY (username) REFERENCES Player(username)
);

create Table Status_effects (
    effect_name varchar(100) Primary Key,
    effect_info Text,
    username varchar(100) Not Null, 
    FOREIGN KEY (username) REFERENCES Player(username)
);


CREATE TABLE Enemy_Biome (
    enemy_name VARCHAR(100),
    biome_name VARCHAR(100),
    PRIMARY KEY (enemy_name, biome_name),
    FOREIGN KEY (enemy_name) REFERENCES Enemies(enemy_name)
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
    FOREIGN KEY (biome_name) REFERENCES Biomes(biome_name)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

Insert Into Cosmetics(skin_name, skin_description, unlock_condition) Values
('Cultist Outfit', 'Do you have a minute to talk about our Lord and Saviour?', 'Drops from any of the corpses scattered inside the large floating islands of Fractured Shrines; can be instantly equipped with the Homunculus Rune'),
('Flawless Concierge Outfit', 'Garb sported by the lowliest of achievers...', 'Defeat the Concierge without taking damage'),
('Golden Outfit', 'You definitely wont go unnoticed wearing this.', 'Specialist Shop in the Prisoners Quarters; costs 10,000 gold or a 50-kill curse');

Insert Into Biomes(biome_name, biome_status_effect, biome_requirements, biome_gimmick) Values
('Toxic Sewers', 'none', 'vine rune', 'pools of poison'),
('Forgotten Sepulcher', 'darkness', 'teleportation runem', 'spikes'),
('Undying Shores', 'none', 'cultist outfit', 'none');

INSERT INTO Player (username, status_effects, cosmetics, skin_name, biome_name) Values
('Dave', NULL, 'Cultist Outfit', 'Cultist Outfit', 'Toxic Sewers'),
('Garry', NULL, 'Festive Outfit', 'Golden Outfit', 'Undying Shores'),
('Larry', NULL, 'Galaxy Outfit', 'Flawless Concierge Outfit', 'Forgotten Sepulcher');

Insert Into Equip(item_name, dmgtype, dps, item_info, atk_speed, atk_range, crit_dmg_conditions, attributes, item_effect, item_cooldown, username) Values
('Twin Daggers','Melee Weapon',173,'the Twin Daggers are a sword-type melee weapon which deal a critical hit on the third strike of each combo',1.07,'close quarters','Always deals a high-damage critical hit on the third hit of each combo',NULL,'Increases your movement speed for 5 seconds after a critical hit',NULL,'Dave'),
('BroadSword','Melee Weapon',176,'The Broadsword is a heavy melee weapon which swings slowly, but deals critical damage during subsequent attacks in its combo',2.25,'close quarters,third hit has slightly longer range than the previous two','The second and third hits will always deal a critical hit',NULL,'if legendary grade grants a shield upon killing an enemy', NULL,'larry'),
('Laser Glaive','ranged weapon',70,'The Laser Glaive is a ranged weapon that is focused on dealing with multiple enemies',1.2,Null,'deals crit damage after two bounces',NULL,'The projectile can bounce up to 6 times, Each additional hit after the first crit increases the projectile speed by 10% and its damage by 25%',0.8,'Garry');

Insert Into Enemies(enemy_name, enemyhealth, enemy_resist, dmg_type, dmg_effect, dmg_number, moveset) Values
('Scorpion', 100, NULL, 'melee, projectile', 'poison', NULL, 'Tail swipe, venom shot'),
('The Concierge', 4000, NULL, 'ranged, AOE, melee', 'stun with "shout" attack', NULL, 'attack: stab, firestrike, leap,defence: shout, Aura of laceration'),
('Ground Shaker', 300, 'immune to stun, cannot be harmed from the back', 'melee, ranged, AOE', 'ranged and AOE cannot be parried or dodge rolled',NULL, 'Avalanche, swipe combo');

Insert Into Player_mutations(mutation_name, mutation_effect, cost, mutation_type, username) Values
('Predator', 'invisibility', 'killing an enemy with melee strike', 'brutality', 'Garry'),
('Point Blank', 'attacks inflicts +30% bonus damage', 'close-ranged attack with ranged weapon', 'tactics','Larry'),
('What doesnt kill me', 'recover 2% of max HP', 'parrying a melee attack', 'survival','Dave');

Insert Into Status_effects(effect_name, effect_info, username) Values
('Bleed', 'Bleed effects cause enemies to take large amounts of damage over the course of their duration. If 5 bleed effects are inflicted upon an enemy, all of the damage they would have inflicted over the course of their duration is dealt all at once in a sudden burst of blood. Enemies that are bleeding will be visibly squirting blood.','Garry'),
('Slow', 'Slow reduces enemy movement and attack speed to around half of what it would normally be, making enemies easier to engage as they will not be able to attack as quickly.','Larry'),
('Damage Resistance', 'Damage resistance reduces the damage of incoming hits by a percentage. It is most commonly used by the player, as multiple skills, affixes, and mutations will grant this buff to the player.','Dave');

Insert into Enemy_Biome (enemy_name, biome_name) Values
('Scorpion', 'Toxic Sewers');


this is a test
