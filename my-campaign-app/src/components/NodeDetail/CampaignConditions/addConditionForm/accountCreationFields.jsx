import React from 'react';
import { Form, Input } from 'antd';

const AccountCreationFields = () => (
  <Form.Item
    name="value"
    label="Days since account creation"
    rules={[{ required: true, message: 'Please select an amount of days' }]}
  >
    <Input type="number" />
  </Form.Item>
);

export default AccountCreationFields;
