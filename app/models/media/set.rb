# -*- encoding : utf-8 -*-
module Media
  def self.table_name_prefix
    "media_"
  end

  class Set < ActiveRecord::Base # TODO rename to Media::Group
    include Resource
  
    has_dag_links :link_class_name => 'Media::SetLink'
  
    belongs_to :user
    has_and_belongs_to_many :media_entries, :join_table => "media_entries_media_sets",
                                            :foreign_key => "media_set_id" do
      def push_uniq(members)
        i = 0
        Array(members).each do |member|
          next if exists? member
          push member
          i += 1
        end
        i
      end
    end
    
    def self.find_by_id_or_create_by_title(values, user)
      records = Array(values).map do |v|
                        if v.is_a?(Numeric) or !!v.match(/\A[+-]?\d+\Z/) # TODO path to String#is_numeric? method
                          a = where(:id => v).first
                        else
                          mk = MetaKey.find_by_label("title")
                          a = user.media_sets.create(:meta_data_attributes => [{:meta_key_id => mk.id, :value => v}])
                        end
                        a
                    end
      records.compact
    end
  
  ########################################################
  
    # TODO validation: if dynamic media_set, then media_entries must be empty
    # TODO validation: if static media_set, then query must be nil
  
  ########################################################
  
    default_scope order("type ASC, updated_at DESC")
  
    scope :static, where("query IS NULL")
    scope :dynamic, where("query IS NOT NULL")
    
    scope :collections, where(:type => "Media::Collection")
    scope :sets, where(:type => "Media::Set")
    scope :projects, where(:type => "Media::Project")
  
  ########################################################
    def to_s
      s = "#{title} " 
      s += "- %s " % self.class.name.split('::').last # OPTIMIZE get class name without module name
      # TODO filter accessible ??
      # s += (static? ? "(#{MediaResource.accessible_by_user(current_user).by_media_set(self).count})" : "(#{MediaResource.accessible_by_user(current_user).by_media_set(self).search(query).count}) [#{query}]")
      s += (static? ? "(#{media_entries.count})" : "(#{MediaResource.by_media_set(self).search(query).count}) [#{query}]")
    end
  
  ########################################################

    def as_json(options={})
      h = { :is_set => true }
      super(options).merge(h)
  end

  ########################################################
  
    def dynamic?
      not static?
    end
  
    def static?
      query.nil?
    end
  
  end

end
