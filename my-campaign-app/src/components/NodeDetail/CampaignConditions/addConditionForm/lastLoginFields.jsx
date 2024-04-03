import React from 'react';
import { Form, Input } from 'antd';

const LastLoginFields = () => (
  <Form.Item
    name="value"
    label="Days since last login"
    rules={[{ required: true, message: 'Please select an amount of days' }]}
  >
    <Input type="number" />
  </Form.Item>
);

export default LastLoginFields;
