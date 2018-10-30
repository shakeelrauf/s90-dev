class Admin::YmlChecker

  # The directory to scan
  # check_values: Show an error if the french value is equivant to the english
  #               That means a string that hasn't been translated
  def check(dir, check_values=false)
    # Compare the languages 2 by 2
    # first check that every fr key is in en
    check_lang(dir, "fr", "en", check_values)
    check_lang(dir, "en", "fr", check_values)
  end

  EXCLUDED_FILES = [".", "..", "doorkeeper.en.yml", "en_mongoid.yml", "fr_mongoid.yml"]

  # YML equivalence check
  def check_lang(dir, l1, l2, check_values)
    d = Dir.new(dir)
    d.each do |fn|
      next if (EXCLUDED_FILES.include?(fn))
      if (fn.start_with?(l1))
        p1 = "#{dir}/#{fn}"
        fn2 = fn.gsub(Regexp.new(l1), l2)
        # puts "================= #{fn}"
        errors = 0
        l1_yml = YAML.load(File.read(p1))
        p2 = "#{dir}/#{fn2}"
        begin
          l2_yml = YAML.load(File.read(p2))
        rescue
          puts "#{fn}: ERROR: File not found: #{p2}"
          next
        end

        # Recursively check the hashes from the top
        l1_yml[l1].each do |k, v|
          base_key = "#{l2}.#{k}"
          errors += check_keys(l1_yml[l1][k], l2_yml[l2][k], fn2, base_key, check_values)
          break if (errors >= 10)
        end
        next if (errors >= 10)
        puts "================= #{fn}: OK" if (errors == 0)
      end
    end
  end

  def check_keys(l1_hash, l2_hash, fn2, base_key, check_values)
    if (l2_hash.class != Hash)
      puts "#{fn2}: Missing parent section: #{base_key}"
      return 1
    end

    errors = 0
    l1_hash.each do |k, v|
      if (!l2_hash.has_key?(k))
        puts "#{fn2}: Missing key: #{base_key}.#{k}"
        errors += 1
      elsif (check_value(l1_hash, l2_hash, fn2, base_key, check_values, k) > 0)
        errors += 1
      elsif (v.class == Hash)
        errors += check_keys(l1_hash[k], l2_hash[k], fn2, "#{base_key}.#{k}", check_values)
      end
    end
    return errors
  end

  def check_value(l1_hash, l2_hash, fn2, base_key, check_values, k)
    return 0 if (!check_values)
    v = l1_hash[k]
    return 0 if (v.class == Hash)
    v = v.downcase
    # exclude equivalence
    return 0 if (EQUIVALENT_WORDS.include?(v))
    if(l1_hash[k] == l2_hash[k])
      puts "#{fn2}: Identical values: #{base_key}.#{k}: #{v}"
      return 1
    end
    return 0
  end

  # Words that are the same in french an english
  # after downcasing
  EQUIVALENT_WORDS = [
                        "configuration",
                        "total",
                      ]

end
