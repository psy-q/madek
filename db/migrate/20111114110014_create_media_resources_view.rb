class CreateMediaResourcesView < ActiveRecord::Migration
  def up
    #var#1#
    # CREATE VIEW media_resources AS 
    # (SELECT id, type, user_id, NULL AS media_file_id, created_at, updated_at FROM media_sets)
    # UNION
    # (SELECT me.id, "MediaEntry" AS type, us.user_id, media_file_id, me.created_at, me.updated_at
    #   FROM media_entries AS me JOIN upload_sessions AS us ON me.upload_session_id = us.id);
    
    #var#2#
    # CREATE VIEW media_resources AS 
    # (SELECT id, type, user_id, NULL AS upload_session_id, NULL AS media_file_id, created_at, updated_at FROM media_sets)
    # UNION
    # (SELECT id, "MediaEntry" AS type, NULL AS user_id, upload_session_id, media_file_id, created_at, updated_at FROM media_entries);
    
    #var#3#
    # CREATE VIEW media_resources AS
    # (SELECT r.id, type, user_id, NULL AS upload_session_id, NULL AS media_file_id, r.created_at, r.updated_at,
    # subject_id, subject_type, action_bits, action_mask
    # FROM media_sets AS r
    # INNER JOIN permissions AS p ON p.resource_id=r.id AND p.resource_type="Media::Set")
    # UNION
    # (SELECT r.id, "MediaEntry" AS type, NULL AS user_id, upload_session_id, media_file_id, r.created_at, r.updated_at,
    # subject_id, subject_type, action_bits, action_mask
    # FROM media_entries AS r
    # INNER JOIN permissions AS p ON p.resource_id=r.id AND p.resource_type="MediaEntry")

    execute("CREATE VIEW media_resources AS " \
              "(SELECT id, type, user_id, NULL AS upload_session_id, NULL AS media_file_id, created_at, updated_at FROM media_sets) " \
              "UNION " \
              "(SELECT me.id, 'MediaEntry' AS type, us.user_id, upload_session_id, media_file_id, me.created_at, me.updated_at " \
              " FROM media_entries AS me JOIN upload_sessions AS us ON me.upload_session_id = us.id AND us.is_complete = 1);")
  end

  def down
    execute("DROP VIEW IF EXISTS media_resources")
  end
end
