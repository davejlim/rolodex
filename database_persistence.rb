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
      ORDER BY contacts.id ASC
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

  def create_contact(name, phone_number, email, category_id)
    sql = <<~SQL
      INSERT INTO contacts(name, phone_number, email, category_id)
      VALUES($1, $2, $3, $4)
    SQL

    query(sql, name, phone_number, email, category_id)
  end

  def delete_contact(id)
    sql = <<~SQL
      DELETE FROM contacts
      WHERE id = $1
    SQL

    query(sql, id)
  end
end