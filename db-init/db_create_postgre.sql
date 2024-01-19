-- Table user
CREATE TABLE IF NOT EXISTS public.user (
    user_id INT NOT NULL PRIMARY KEY,
    username VARCHAR(128) NOT NULL
);


-- Table model
CREATE TABLE IF NOT EXISTS public.model (
    model_id INT NOT NULL PRIMARY KEY,
    creator_id INT NOT NULL,
    last_editor_id INT NOT NULL,
    last_update_time TIMESTAMP NOT NULL,

    FOREIGN KEY (creator_id) REFERENCES "user"(user_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (last_editor_id) REFERENCES "user"(user_id) ON DELETE NO ACTION ON UPDATE NO ACTION
);


-- Table access_list
CREATE TABLE IF NOT EXISTS public.access_list (
    user_id INT NOT NULL,
    model_id INT NOT NULL,
    read_permission BOOLEAN,
    write_permission BOOLEAN,

    PRIMARY KEY (user_id, model_id),
    FOREIGN KEY (user_id) REFERENCES "user"(user_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (model_id) REFERENCES model(model_id) ON DELETE CASCADE ON UPDATE CASCADE
);


-- Table plane
CREATE TABLE IF NOT EXISTS public.plane (
    plane_id INT NOT NULL PRIMARY KEY,
    model_id INT NOT NULL,
    point_id INT NULL,

    vector1_x DOUBLE PRECISION NOT NULL,
    vector1_y DOUBLE PRECISION NOT NULL,
    vector1_z DOUBLE PRECISION NOT NULL,

    vector2_x DOUBLE PRECISION NOT NULL,
    vector2_y DOUBLE PRECISION NOT NULL,
    vector2_z DOUBLE PRECISION NOT NULL,

    FOREIGN KEY (model_id) REFERENCES model(model_id) ON DELETE CASCADE ON UPDATE CASCADE
);


-- Table sketch
CREATE TABLE IF NOT EXISTS public.sketch (
    sketch_id INT NOT NULL PRIMARY KEY,
    plane_id INT NOT NULL,

    FOREIGN KEY (plane_id) REFERENCES plane(plane_id) ON DELETE CASCADE ON UPDATE CASCADE
);


-- Table entity
CREATE TABLE IF NOT EXISTS public.entity (
    entity_id INT NOT NULL PRIMARY KEY,
    sketch_id INT NOT NULL,

    FOREIGN KEY (sketch_id) REFERENCES sketch(sketch_id) ON DELETE CASCADE ON UPDATE CASCADE
);


-- Table param
CREATE TABLE IF NOT EXISTS public.param  (
    param_id INT NOT NULL PRIMARY KEY,
    value  DOUBLE PRECISION NOT NULL
);


-- Table object_type 
CREATE TABLE IF NOT EXISTS public.object_type (
    object_type_id INT NOT NULL PRIMARY KEY,
    name VARCHAR(128) NOT NULL,
    free_degree INT NOT NULL
);


-- Table object
CREATE TABLE IF NOT EXISTS public.object  (
    object_id INT NOT NULL PRIMARY KEY,
    object_type_id INT NOT NULL,
    parent_id INT,
    num INT,

    FOREIGN KEY (object_type_id) REFERENCES object_type(object_type_id) ON DELETE NO ACTION ON UPDATE NO ACTION,
    FOREIGN KEY (object_id) REFERENCES entity(entity_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (parent_id) REFERENCES "object"(object_id) ON DELETE CASCADE ON UPDATE CASCADE
);


-- Table object_param
CREATE TABLE IF NOT EXISTS public.object_param  (
    object_id INT NOT NULL,
    param_id INT NOT NULL,
    num INT NULL,

    PRIMARY KEY (object_id, param_id),
    FOREIGN KEY (param_id) REFERENCES "param"(param_id) ON DELETE NO ACTION ON UPDATE NO ACTION,
    FOREIGN KEY (object_id) REFERENCES "object"(object_id) ON DELETE CASCADE ON UPDATE CASCADE
);


-- Table constraint_type
CREATE TABLE IF NOT EXISTS public.constraint_type  (
    constraint_type_id INT NOT NULL PRIMARY KEY,
    name VARCHAR(128) NOT NULL,
    is_parametric BOOLEAN NOT NULL
);


-- Table constraint
CREATE TABLE IF NOT EXISTS public.constraint (
    constraint_id INT NOT NULL PRIMARY KEY,
    constraint_type_id INT NOT NULL,

    FOREIGN KEY (constraint_type_id) REFERENCES constraint_type(constraint_type_id) ON DELETE NO ACTION ON UPDATE NO ACTION,
    FOREIGN KEY (constraint_id) REFERENCES entity(entity_id) ON DELETE CASCADE ON UPDATE CASCADE
);


-- Table constraint_info
CREATE TABLE IF NOT EXISTS public.constraint_info (
    constraint_id INT NOT NULL,
    object_id  INT NOT NULL,

    PRIMARY KEY (constraint_id, object_id),
    FOREIGN KEY (constraint_id) REFERENCES "constraint"(constraint_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (object_id) REFERENCES "object"(object_id) ON DELETE CASCADE ON UPDATE CASCADE
);


-- Table constraint_param 
CREATE TABLE IF NOT EXISTS public.constraint_param  (
    constraint_id INT NOT NULL,
    param_id INT NOT NULL,

    PRIMARY KEY (constraint_id, param_id),
    FOREIGN KEY (constraint_id) REFERENCES "constraint"(constraint_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (param_id) REFERENCES "param"(param_id) ON DELETE CASCADE ON UPDATE CASCADE
);

ALTER TABLE public.plane ADD CONSTRAINT fk_plane_object FOREIGN KEY (point_id) REFERENCES object(object_id) ON DELETE CASCADE ON UPDATE CASCADE;


INSERT INTO  "object_type" ("object_type_id","name","free_degree") VALUES (1,'Point',2);
INSERT INTO  "object_type" ("object_type_id","name","free_degree") VALUES (2,'Segment',4);
INSERT INTO  "object_type" ("object_type_id","name","free_degree") VALUES (3,'Circle',3);
INSERT INTO  "object_type" ("object_type_id","name","free_degree") VALUES (4,'Arc',5); 

INSERT INTO "constraint_type" ("constraint_type_id","name","is_parametric") VALUES (0,'Fixed',false);
INSERT INTO "constraint_type" ("constraint_type_id","name","is_parametric") VALUES (1,'Equal',false);
INSERT INTO "constraint_type" ("constraint_type_id","name","is_parametric") VALUES (2,'Vertical',false);
INSERT INTO "constraint_type" ("constraint_type_id","name","is_parametric") VALUES (3,'Horizontal',false);
INSERT INTO "constraint_type" ("constraint_type_id","name","is_parametric") VALUES (4,'Parallel',false);
INSERT INTO "constraint_type" ("constraint_type_id","name","is_parametric") VALUES (5,'Ortho',false);
INSERT INTO "constraint_type" ("constraint_type_id","name","is_parametric") VALUES (6,'Tangent',false);
INSERT INTO "constraint_type" ("constraint_type_id","name","is_parametric") VALUES (7,'Coincident',false);
INSERT INTO "constraint_type" ("constraint_type_id","name","is_parametric") VALUES (8,'Midpoint',false);
INSERT INTO "constraint_type" ("constraint_type_id","name","is_parametric") VALUES (9,'Collinear',false);
INSERT INTO "constraint_type" ("constraint_type_id","name","is_parametric") VALUES (10,'Symmetric',false);
INSERT INTO "constraint_type" ("constraint_type_id","name","is_parametric") VALUES (11,'Concentric',false);
INSERT INTO "constraint_type" ("constraint_type_id","name","is_parametric") VALUES (12,'Arcbase',false);
INSERT INTO "constraint_type" ("constraint_type_id","name","is_parametric") VALUES (13,'Distance',true);
INSERT INTO "constraint_type" ("constraint_type_id","name","is_parametric") VALUES (14,'Angle',true);
INSERT INTO "constraint_type" ("constraint_type_id","name","is_parametric") VALUES (15,'Dimension',true);



