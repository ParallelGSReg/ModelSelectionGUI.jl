import { mount } from '@vue/test-utils';
import TheFooter from '../TheFooter.vue';
import constants from '../../constants/index.js'



// Create a mock object for this.$constants
const constantsMock = {
  API: 'https://example.com/api',
};

// Mount the component with the $constants property provided
const wrapper = mount(TheFooter, {
  provide: {
    $constants: constantsMock,
  },
});

const component = wrapper.vm;


// Access the rendered text
const renderedText = wrapper.text();

// Assert that the text is "anduvo"
expect(renderedText).toBe("Global Search Regression");