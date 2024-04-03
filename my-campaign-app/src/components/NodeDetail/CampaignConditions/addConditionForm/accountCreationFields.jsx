import React from 'react';
import { Form, Input } from 'antd';

const AccountCreationFields = () => (
  <Form.Item
    name="value"
    label="Días desde la creación de la cuenta"
    rules={[{ required: true, message: 'Por favor ingrese la cantidad de días!' }]}
  >
    <Input type="number" />
  </Form.Item>
);

export default AccountCreationFields;
