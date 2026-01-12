-- CreateTable
CREATE TABLE "users" (
    "user_id" SERIAL NOT NULL,
    "name" VARCHAR(100) NOT NULL,
    "email" VARCHAR(100) NOT NULL,
    "password" VARCHAR(255) NOT NULL,

    CONSTRAINT "user_pkey" PRIMARY KEY ("user_id")
);

-- CreateTable
CREATE TABLE "chatai" (
    "chat_id" SERIAL NOT NULL,
    "user_id" INTEGER,
    "message" TEXT,
    "response" TEXT,
    "timestamp" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "chatai_pkey" PRIMARY KEY ("chat_id")
);

-- CreateTable
CREATE TABLE "diaryentries" (
    "entry_id" SERIAL NOT NULL,
    "user_id" INTEGER,
    "mood" VARCHAR(50),
    "event" TEXT,
    "solution" TEXT,
    "improve" TEXT,

    CONSTRAINT "diaryentries_pkey" PRIMARY KEY ("entry_id")
);

-- CreateTable
CREATE TABLE "keywordreplies" (
    "keyword_id" SERIAL NOT NULL,
    "keyword" VARCHAR(50),
    "response" TEXT,

    CONSTRAINT "keywordreplies_pkey" PRIMARY KEY ("keyword_id")
);

-- CreateTable
CREATE TABLE "mood" (
    "mood_id" SERIAL NOT NULL,
    "user_id" INTEGER,
    "mood" VARCHAR(50),
    "note" TEXT,
    "timestamp" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "mood_pkey" PRIMARY KEY ("mood_id")
);

-- CreateTable
CREATE TABLE "password_reset_tokens" (
    "id" SERIAL NOT NULL,
    "user_id" INTEGER NOT NULL,
    "token_hash" TEXT NOT NULL,
    "expires_at" TIMESTAMPTZ(6) NOT NULL,
    "used_at" TIMESTAMPTZ(6),
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "password_reset_tokens_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "quizresults" (
    "quiz_id" SERIAL NOT NULL,
    "user_id" INTEGER,
    "total_score" INTEGER,
    "level" VARCHAR(50),
    "timestamp" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "quizresults_pkey" PRIMARY KEY ("quiz_id")
);

-- CreateTable
CREATE TABLE "relaxsound" (
    "sound_id" SERIAL NOT NULL,
    "title" VARCHAR(100),
    "audio_url" VARCHAR(255),

    CONSTRAINT "relaxsound_pkey" PRIMARY KEY ("sound_id")
);

-- CreateIndex
CREATE UNIQUE INDEX "user_email_key" ON "users"("email");

-- CreateIndex
CREATE UNIQUE INDEX "keywordreplies_keyword_key" ON "keywordreplies"("keyword");

-- AddForeignKey
ALTER TABLE "password_reset_tokens" ADD CONSTRAINT "password_reset_tokens_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("user_id") ON DELETE CASCADE ON UPDATE NO ACTION;
