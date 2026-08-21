import React from 'react';
import Navbar from '../components/Navbar';

const Investigations = () => {
  return (
    <div className="min-h-screen bg-white dark:bg-gray-900">
      <Navbar />
      <main className="container py-8">
        <h1 className="text-4xl font-bold mb-8">My Investigations</h1>
        <div className="card text-center py-12 text-gray-500 dark:text-gray-400">
          <p>No investigations yet. Start by analyzing a phone number on the home page.</p>
        </div>
      </main>
    </div>
  );
};

export default Investigations;
