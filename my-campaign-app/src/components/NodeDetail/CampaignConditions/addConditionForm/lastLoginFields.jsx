import React from 'react';
import { Form, Input } from 'antd';

const LastLoginFields = () => (
  <Form.Item
    name="value"
    label="Días desde el último login"
    rules={[{ required: true, message: 'Por favor ingrese la cantidad de días!' }]}
  >
    <Input type="number" />
  </Form.Item>
);

export default LastLoginFields;
