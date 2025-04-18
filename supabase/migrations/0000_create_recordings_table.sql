
-- Create recordings table
CREATE TABLE IF NOT EXISTS recordings (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title TEXT NOT NULL,
  audio_url TEXT,
  transcription TEXT,
  duration INTEGER NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL
);

-- Create RLS policies
ALTER TABLE recordings ENABLE ROW LEVEL SECURITY;

-- Create storage bucket for audio files
INSERT INTO storage.buckets (id, name, public) 
VALUES ('audio_recordings', 'audio_recordings', true)
ON CONFLICT (id) DO NOTHING;

-- Set up storage policy
CREATE POLICY "Public Access to Audio Recordings" 
ON storage.objects FOR SELECT 
USING (bucket_id = 'audio_recordings');

CREATE POLICY "Insert Audio Recordings" 
ON storage.objects FOR INSERT 
WITH CHECK (bucket_id = 'audio_recordings');