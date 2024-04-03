// src/components/AddCampaignModal.js
import React from 'react';
import { Modal, Form, Input, Button } from 'antd';

const AddCampaignModal = ({ isVisible, onCreate, onCancel }) => {
  const [form] = Form.useForm();

  return (
    <Modal
      title="Add New Campaign"
      visible={isVisible}
      onCancel={onCancel}
      footer={null}
    >
      <Form
        form={form}
        name="new_campaign_form"
        onFinish={onCreate}
      >
        <Form.Item
          name="name"
          rules={[{ required: true, message: 'Please input the campaign name!' }]}
        >
          <Input placeholder="Campaign Name" />
        </Form.Item>
        <Form.Item
          name="description"
          rules={[{ required: true, message: 'Please input the campaign description!' }]}
        >
          <Input.TextArea placeholder="Campaign Description" />
        </Form.Item>
        <Form.Item>
          <Button type="primary" htmlType="submit">
            Add Campaign
          </Button>
        </Form.Item>
      </Form>
    </Modal>
  );
};

export default AddCampaignModal;
