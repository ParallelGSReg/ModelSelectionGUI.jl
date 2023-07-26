 <template>
 <footer class="footer text-muted">
    <div class="footer-links-container container-fluid">
      <ul class="footer-links" id="listProyectInfo">
        <li><a href="https://parallelgsreg.github.io/GlobalSearchRegression.jl/">About</a></li>
        <li><a href="https://github.com/ParallelGSReg/GlobalSearchRegression.jl">GitHub</a></li>
        <li><a href="https://julialang.org/">Julia</a></li>
      </ul>
      <p><b>Global Search Regression</b> is licensed under the <a href="https://github.com/ParallelGSReg/GlobalSearchRegression.jl/blob/master/LICENSE.md" target="_blank" rel="license noopener">MIT License</a>.</p>
  <!--  <div id="server-info">
      <p><b>Server Info:</b></p>
      <ul class="footer-links" id="listServerInfo">
        <li>Julia Version: {{julia_version}}</li>
        <li>cores: {{cores}}</li>
        <li>Model Selection Version: {{model_selecion_version}}</li>
        <li>Jobs Queue Size: {{jobs_queue_size}}</li>
        <li>Workers: {{nworkers}}</li>
      </ul>
    </div> -->
    </div>
  </footer>
 </template>



<script>
import axios from 'axios'

export default {
  data(){
    return{
      julia_version : "",
      cores : 1,
      model_selecion_version : "",
      jobs_queue_size : 0,
      nworkers :1 
    }
  },
  created(){
    axios.get(this.$constants.API.host + this.$constants.API.paths.server_info).then((response)=>{
      console.log(response)
    })
  }
  
  }

</script>


<style>

.footer {
position: absolute;
bottom: 0;
width: 100%;
background-color: #ccc;
display: flex;
align-items: baseline;
justify-content: center;
text-align: center;
}


.footer-links li {
display: inline-block;
padding-right: 0.5rem;
}


</style>
