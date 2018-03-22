require 'google-cloud-storage'
require 'carrierwave'
require 'carrierwave/google/storage/version'
require 'carrierwave/storage/gcloud'
require 'carrierwave/storage/gcloud_file'
require 'carrierwave/storage/gcloud_options'
require 'carrierwave/support/uri_filename'

module CarrierWave
  module Uploader
    class Base
      #   * `auth`, `auth_read`, `authenticated`, `authenticated_read`,
      #     `authenticatedRead` - File owner gets OWNER access, and
      #     allAuthenticatedUsers get READER access.
      #   * `owner_full`, `bucketOwnerFullControl` - File owner gets OWNER
      #     access, and project team owners get OWNER access.
      #   * `owner_read`, `bucketOwnerRead` - File owner gets OWNER access,
      #     and project team owners get READER access.
      #   * `private` - File owner gets OWNER access.
      #   * `project_private`, `projectPrivate` - File owner gets OWNER
      #     access, and project team members get access according to their
      #     roles.
      #   * `public`, `public_read`, `publicRead` - File owner gets OWNER
      #     access, and allUsers get READER access.
      ACCEPTED_GOOGLE_CLOUD_ACL = %w[
        auth
        auth_read
        authenticated
        authenticated_read
        authenticatedRead

        owner_full
        bucketOwnerFullControl

        owner_read
        bucketOwnerRead

        private

        project_private
        projectPrivate

        public
        public_read
        publicRead
      ].freeze

      GCloudConfigurationError = Class.new(StandardError)

      add_config :gcloud_attributes
      add_config :gcloud_read_options
      add_config :gcloud_write_options
      add_config :gcloud_bucket
      add_config :gcloud_bucket_is_public
      add_config :gcloud_credentials
      add_config :gcloud_authenticated_url_expiration
      add_config :gcloud_acl

      configure do |config|
        config.storage_engines[:gcloud] = 'CarrierWave::Storage::Gcloud'
      end

      def self.gcloud_acl=(acl)
        @gcloud_acl = normalized_acl(acl)
      end

      def self.normalized_acl(acl)
        return if acl.nil?
        normalized = acl.to_s.gsub('-', '_')

        unless ACCEPTED_GOOGLE_CLOUD_ACL.include?(normalized)
          raise GCloudConfigurationError, "Invalid ACL option: #{normalized}"
        end

        normalized
      end

      def gcloud_acl=(acl)
        @gcloud_acl = self.class.normalized_acl(acl)
      end
    end
  end
end
