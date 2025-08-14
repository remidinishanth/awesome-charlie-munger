module Jekyll
  class ReadmeExtractor < Generator
    safe true
    priority :high

    def generate(site)
      readme_path = File.join(site.source, 'README.md')
      return unless File.exist?(readme_path)

      readme_content = File.read(readme_path)
      
      # Extract sections from README
      sections = extract_sections(readme_content)
      
      # Make sections available to Jekyll pages
      site.data['readme_sections'] = sections
    end

    private

    def extract_sections(content)
      sections = {}
      current_section = nil
      current_content = []

      content.lines.each do |line|
        if line.match(/^## (.+)/)
          # Save previous section
          if current_section
            sections[current_section] = current_content.join
          end
          
          # Start new section
          current_section = $1.downcase.gsub(/[^a-z0-9]/, '_').gsub(/_+/, '_').gsub(/^_|_$/, '')
          current_content = []
        elsif current_section
          current_content << line
        end
      end

      # Save last section
      if current_section
        sections[current_section] = current_content.join
      end

      sections
    end
  end
end
