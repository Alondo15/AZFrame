-- =========================
-- ENUM TYPES
-- =========================

CREATE TYPE follow_status AS ENUM ('pending', 'accepted', 'blocked');
CREATE TYPE post_visibility AS ENUM ('public', 'followers', 'private');
CREATE TYPE media_type AS ENUM ('image', 'video');
CREATE TYPE conversation_type AS ENUM ('private', 'group');
CREATE TYPE group_visibility AS ENUM ('public', 'private');
CREATE TYPE group_role AS ENUM ('member', 'admin');
CREATE TYPE membership_status AS ENUM ('pending', 'approved');
CREATE TYPE event_type AS ENUM ('event', 'open_photoshoot');
CREATE TYPE event_visibility AS ENUM ('public', 'followers', 'invite');
CREATE TYPE participation_status AS ENUM ('interested', 'going', 'declined');

-- =========================
-- USERS & PROFILES
-- =========================

CREATE TABLE users (
    id BIGSERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    email_verified_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE profiles (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT UNIQUE REFERENCES users(id) ON DELETE CASCADE,
    full_name VARCHAR(255),
    bio TEXT,
    avatar_media_id BIGINT,
    cover_media_id BIGINT,
    location VARCHAR(255),
    website VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =========================
-- FOLLOWING SYSTEM
-- =========================

CREATE TABLE follows (
    id BIGSERIAL PRIMARY KEY,
    follower_id BIGINT REFERENCES users(id) ON DELETE CASCADE,
    followed_id BIGINT REFERENCES users(id) ON DELETE CASCADE,
    status follow_status NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (follower_id, followed_id)
);

-- =========================
-- MEDIA
-- =========================

CREATE TABLE media (
    id BIGSERIAL PRIMARY KEY,
    type media_type NOT NULL,
    path TEXT NOT NULL,
    thumbnail_path TEXT,
    duration INTEGER,
    mime_type VARCHAR(100),
    size BIGINT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =========================
-- POSTS
-- =========================

CREATE TABLE posts (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT REFERENCES users(id) ON DELETE CASCADE,
    content TEXT,
    visibility post_visibility DEFAULT 'public',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL
);

CREATE TABLE post_media (
    post_id BIGINT REFERENCES posts(id) ON DELETE CASCADE,
    media_id BIGINT REFERENCES media(id) ON DELETE CASCADE,
    PRIMARY KEY (post_id, media_id)
);

-- =========================
-- COMMENTS & LIKES
-- =========================

CREATE TABLE comments (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT REFERENCES users(id) ON DELETE CASCADE,
    post_id BIGINT REFERENCES posts(id) ON DELETE CASCADE,
    parent_id BIGINT REFERENCES comments(id) ON DELETE CASCADE,
    content TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL
);

CREATE TABLE likes (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT REFERENCES users(id) ON DELETE CASCADE,
    likeable_type VARCHAR(50) NOT NULL,
    likeable_id BIGINT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_likes_polymorphic ON likes (likeable_type, likeable_id);

-- =========================
-- CHAT SYSTEM
-- =========================

CREATE TABLE conversations (
    id BIGSERIAL PRIMARY KEY,
    type conversation_type NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE conversation_users (
    conversation_id BIGINT REFERENCES conversations(id) ON DELETE CASCADE,
    user_id BIGINT REFERENCES users(id) ON DELETE CASCADE,
    PRIMARY KEY (conversation_id, user_id)
);

CREATE TABLE messages (
    id BIGSERIAL PRIMARY KEY,
    conversation_id BIGINT REFERENCES conversations(id) ON DELETE CASCADE,
    sender_id BIGINT REFERENCES users(id) ON DELETE CASCADE,
    content TEXT,
    media_id BIGINT REFERENCES media(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =========================
-- NOTIFICATIONS
-- =========================

CREATE TABLE notifications (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT REFERENCES users(id) ON DELETE CASCADE,
    type VARCHAR(100) NOT NULL,
    data JSONB NOT NULL,
    read_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =========================
-- GROUPS
-- =========================

CREATE TABLE groups (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    owner_id BIGINT REFERENCES users(id) ON DELETE CASCADE,
    visibility group_visibility DEFAULT 'public',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE group_members (
    group_id BIGINT REFERENCES groups(id) ON DELETE CASCADE,
    user_id BIGINT REFERENCES users(id) ON DELETE CASCADE,
    role group_role DEFAULT 'member',
    status membership_status DEFAULT 'pending',
    PRIMARY KEY (group_id, user_id)
);

-- =========================
-- CAMERA & LENS SYSTEM
-- =========================

CREATE TABLE brands (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) UNIQUE NOT NULL
);

CREATE TABLE cameras (
    id BIGSERIAL PRIMARY KEY,
    brand_id BIGINT REFERENCES brands(id),
    model VARCHAR(255) NOT NULL,
    sensor_type VARCHAR(100),
    release_year INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE lenses (
    id BIGSERIAL PRIMARY KEY,
    brand_id BIGINT REFERENCES brands(id),
    model VARCHAR(255) NOT NULL,
    mount VARCHAR(100),
    focal_length VARCHAR(100),
    aperture VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE user_cameras (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT REFERENCES users(id) ON DELETE CASCADE,
    camera_id BIGINT REFERENCES cameras(id),
    usage_notes TEXT
);

CREATE TABLE user_lenses (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT REFERENCES users(id) ON DELETE CASCADE,
    lens_id BIGINT REFERENCES lenses(id),
    usage_notes TEXT
);

CREATE TABLE reviews (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT REFERENCES users(id) ON DELETE CASCADE,
    reviewable_type VARCHAR(50) NOT NULL,
    reviewable_id BIGINT NOT NULL,
    rating INTEGER CHECK (rating BETWEEN 1 AND 5),
    content TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_reviews_polymorphic ON reviews (reviewable_type, reviewable_id);

-- =========================
-- EVENTS & OPEN PHOTOSHOOTS
-- =========================

CREATE TABLE events (
    id BIGSERIAL PRIMARY KEY,
    creator_id BIGINT REFERENCES users(id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    location VARCHAR(255),
    start_at TIMESTAMP,
    end_at TIMESTAMP,
    type event_type NOT NULL,
    visibility event_visibility DEFAULT 'public',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE event_participants (
    event_id BIGINT REFERENCES events(id) ON DELETE CASCADE,
    user_id BIGINT REFERENCES users(id) ON DELETE CASCADE,
    status participation_status DEFAULT 'interested',
    PRIMARY KEY (event_id, user_id)
);

-- =========================
-- TAGGING SYSTEM
-- =========================

CREATE TABLE tags (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE taggables (
    tag_id BIGINT REFERENCES tags(id) ON DELETE CASCADE,
    taggable_type VARCHAR(50) NOT NULL,
    taggable_id BIGINT NOT NULL,
    PRIMARY KEY (tag_id, taggable_type, taggable_id)
);

CREATE INDEX idx_taggables_polymorphic ON taggables (taggable_type, taggable_id);
