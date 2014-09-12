class ArticlesFullTextSearch < ActiveRecord::Migration
  def self.up
    execute(<<-'eosql'.strip)
      DROP index IF EXISTS articles_fts_idx
    eosql
    execute(<<-'eosql'.strip)
      CREATE INDEX articles_fts_idx ON articles USING gin(to_tsvector('english', coalesce(title,'') || ' ' || coalesce(description,'')));
    eosql
  end

  def self.down
    execute(<<-'eosql'.strip)
      DROP index IF EXISTS articles_fts_idx
    eosql
  end
end