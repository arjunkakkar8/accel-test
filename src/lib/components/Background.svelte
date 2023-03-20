<script>
  import * as THREE from "three";
  import { OrbitControls } from "three/examples/jsm/controls/OrbitControls";

  import vertex from "$lib/shaders/vertex.glsl?raw";
  import fragment from "$lib/shaders/fragment.glsl?raw";
  import image from "$lib/assets/image.jpg";

  import { onMount } from "svelte";
  import { writable } from "svelte/store";

  const MOUSE_SENSITIVITY = 0.05;

  let scene, camera, renderer, canvas, controls, material, mesh;

  let width, height;

  let mouse = writable({ x: 0.5, y: 0.5 });

  let data = {
    startTime: Date.now(),
    endTime: Date.now(),
  };

  const onResize = () => {
    width = window.innerWidth;
    height = window.innerHeight;
    camera.aspect = width / height;
    camera.updateProjectionMatrix();
    renderer.setSize(width, height);
  };

  const tick = () => {
    data.endTime = Date.now();
    requestAnimationFrame(tick);
    material.uniforms.uTime.value += (data.endTime - data.startTime) / 1000;
    renderer.render(scene, camera);
    data.startTime = data.endTime;
  };

  onMount(() => {
    renderer = new THREE.WebGLRenderer({
      canvas: canvas,
      antialias: false,
    });
    renderer.setPixelRatio(window.devicePixelRatio); // Set device pixel ratio
    renderer.setSize(window.innerWidth, window.innerHeight); // Resize renderer
    renderer.setClearColor("#000000", 1); // WebGL background color
    renderer.outputEncoding = THREE.sRGBEncoding;

    camera = new THREE.PerspectiveCamera(
      70,
      window.innerWidth / window.innerHeight,
      0.001,
      10
    );
    camera.position.set(0, 0, 3);

    // controls = new OrbitControls(camera, canvas);
    // controls.enableDamping = true;
    // controls.dampingFactor = 0.05;

    const texture = new THREE.TextureLoader().load(image);
    texture.minFilter = THREE.LinearFilter;

    scene = new THREE.Scene();
    const geometry = new THREE.SphereGeometry(
      2,
      32,
      16,
      (Math.PI * 1) / 3,
      (Math.PI * 1) / 3,
      (Math.PI * 4) / 10,
      (Math.PI * 1) / 5
    );
    material = new THREE.ShaderMaterial({
      extensions: {
        derivatives: "#extention GL_OES_standard_derivatives : enable",
      },
      uniforms: {
        uResolution: { value: new THREE.Vector2(width, height) },
        // uMouse:       { value: new THREE.Vector2(data.mouse.x, data.mouse.y) },
        // uProgress:    { value: data.progress },
        uTexture: { value: texture },
        uTime: { value: 0 },
      },
      side: THREE.DoubleSide,
      // wireframe: true,
      // transparent: true,
      vertexShader: vertex,
      fragmentShader: fragment,
    });
    mesh = new THREE.Mesh(geometry, material);
    scene.add(mesh);

    onResize();
    tick();
  });

  $: if (mesh) {
    mesh.rotation.set(
      ($mouse.y - 0.5) * MOUSE_SENSITIVITY,
      ($mouse.x - 0.5) * MOUSE_SENSITIVITY,
      0
    );
  }
</script>

<svelte:window on:resize={onResize} />

<canvas
  on:mousemove={({ clientX, clientY }) => {
    mouse.set({ x: clientX / width, y: clientY / height });
  }}
  bind:this={canvas}
  style:width={`${width}px`}
  style:height={`${height}px`}
/>
