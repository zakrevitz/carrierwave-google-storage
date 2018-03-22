module CarrierWave
  module Storage
    class GcloudOptions
      attr_reader :uploader

      def initialize(uploader)
        @uploader = uploader
      end

      def read_options
        gcloud_read_options
      end

      def write_options(new_file)
        {
          acl: uploader.gcloud_acl,
          content_type: new_file.content_type
        }.merge(gcloud_write_options)
      end

      def expiration_options(options = {})
        uploader_expiration = uploader.gcloud_authenticated_url_expiration
        { expires: uploader_expiration }.merge(options)
      end

      private

      def gcloud_attributes
        uploader.gcloud_attributes || {}
      end

      def gcloud_read_options
        uploader.gcloud_read_options || {}
      end

      def gcloud_write_options
        uploader.gcloud_write_options || {}
      end
    end
  end
end
