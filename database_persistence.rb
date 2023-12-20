require "pg"

class DatabasePersistence
  def initialize(logger)
    @db = PG.connect(dbname: "rolodex")
    @logger = logger
  end

  def query(statement, *params)
    @logger.info "#{statement}: #{params}"
    @db.exec_params(statement, params)
  end

  def contact_table
    sql = <<~SQL
      SELECT contacts.*, categories.name AS category_name FROM contacts
      LEFT OUTER JOIN categories ON contacts.category_id = categories.id
    SQL

    query(sql)
  end

  def contact_details(id)
    sql = <<~SQL
      SELECT contacts.*, categories.name AS category_name FROM contacts
      LEFT OUTER JOIN categories ON contacts.category_id = categories.id
      WHERE contacts.id = $1
    SQL

    query(sql, id)
  end

  def categories
    sql = <<~SQL
      SELECT * FROM categories
    SQL

    query(sql)
  end

  def update_contact(name, phone_number, email, category_id, id)
    sql = <<~SQL
      UPDATE contacts
      SET name = $1,
      phone_number = $2,
      email = $3,
      category_id = $4
      WHERE id = $5
    SQL

    query(sql, name, phone_number, email, category_id, id)
  end
end