
<template>
  <div>
    <h1>Google Forms</h1>
    <iframe src="https://docs.google.com/forms/d/e/your-form-id/viewform?embedded=true" width="640" height="500" frameborder="0" marginheight="0" marginwidth="0">Loading...</iframe>
  
    <h1>Submit Data</h1>

    <form @submit.prevent="submitForm">
      <input v-model="formData.name" type="text" placeholder="Name" required>
      <input v-model="formData.email" type="email" placeholder="Email" required>
      <button type="submit">Submit</button>
    </form>
    
  </div>
</template>


<script>
export default {
  data() {
    return {
      formData: {
        name: '',
        email: ''
      }
    };
  },
  methods: {
    async submitForm() {
      try {
        await this.$axios.post('/submit', this.formData);
        alert('Form submitted successfully!');
        // Clear the form
        this.formData.name = '';
        this.formData.email = '';
      } catch (error) {
        console.error('Form submission failed:', error);
      }
    }
  }
};
</script>



<!-- Style component -->
<!-- Add "scoped" attribute to limit CSS to this component only -->
<!-- <style scoped>
h3 {
  margin: 40px 0 0;
}
ul {
  list-style-type: none;
  padding: 0;
}
li {
  display: inline-block;
  margin: 0 10px;
}
a {
  color: #42b983;
}
</style> -->
