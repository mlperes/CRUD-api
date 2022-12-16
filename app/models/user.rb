class User < ApplicationRecord
  validates_length_of :name, minimum: 10
  validates_presence_of :name
  validates_uniqueness_of :cpf
  validates_presence_of :cpf
  validate :cpf_is_valid?
  
  private
    def cpf_is_valid?
      errors.add(:cpf, 'Invalid CPF!') unless CPF.valid?(cpf)
    end
end
  