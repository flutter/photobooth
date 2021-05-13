export default `
html, body {
  margin: 0;
  padding: 0;
  height: 100vh;
}

body {
  font-family: "Google Sans", sans-serif;
  font-size: 12px;
  background-color: #ddd;
  display: flex;
  flex-direction: column;
  position: relative;
}

*, ::before, ::after {
  box-sizing: border-box;
}

.backdrop {
  position: fixed;
  left: 0;
  top: 0;
  z-index: -1;
  height: 100%;
  width: 100%;
  background-image: url("{{{assetUrls.bgMobile}}}");
  background-repeat: no-repeat;
  background-position: center;
  background-size: cover;
}

.fixed-photos {
  position: fixed;
  background-repeat: no-repeat;
  background-size: contain;
  z-index: 1;
  display: none;
  width: 780px;
}

main {
  width: 95%;
  max-width: 1000px;
  margin: 0 auto 45px;
  text-align: center;
  flex: 1 0 auto;
  z-index: 10;
  position: relative;
}

.share-image {
  margin: 2rem auto;
  width: 90%;
  transform: rotate(-5deg);
}

.share-image img {
  width: 100%;
  box-shadow: -3px 9px 7px 1px rgba(0, 0, 0, 0.3);
}

.share-image.no-shadow img {
  box-shadow: none;
}

h1, h2 {
  color: white;
  margin-block-start: 0;
  margin-block-end: 0;
}

h1 {
  line-height: 1.2;
  font-size: 32px;
  font-weight: 500;
  width: 80%;
  margin: 0 auto 15px;
}

h2 {
  line-height: 1.3;
  font-size: 18px;
  font-weight: 100;
  width: 85%;
  margin: 0 auto 35px;
}

.share-btn {
  display: inline-block;
  font-weight: 400;
  line-height: 1.5;
  text-align: center;
  text-decoration: none;
  line-height: 1;
  padding: 16px 0;
  background-color: #428eff;
  color: white;
  font-size: 18px;
  border-radius: 50px;
  width: 208px;
}

footer {
  width: 100%;
  color: white;
  font-size: 14px;
  font-weight: 100;
  flex-direction: column;
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 0 5% 1.5rem;
  text-align: center;
  position: relative;
  flex-shrink: 0;
  z-index: 10;
  position: relative;
}

footer a {
  color: white;
  text-decoration: none;
  white-space: nowrap;
}

footer a:hover {
  text-decoration: underline;
}

footer ul {
  margin: 0;
  padding: 0;
  line-height: 2;
}

footer .left {
  font-size: 16px;
  font-weight: 400;
  margin-bottom: 17px;
}

footer .left a {
  text-decoration: underline;
}

footer li {
  display: inline;
  margin-left: 1rem;
}

@media (min-width: 375px) {
  h1 { width: 67%; }
  h2 { width: 75%; }
}

@media (min-width: 768px) {
  .backdrop {
    background-image: url("{{{assetUrls.bg}}}");
  }

  .fixed-photos {
    display: block;
  }

  .fixed-photos.left  {
    top: -151px;
    left: -550px;
  }

  .fixed-photos.right  {
    top: -110px;
    right: -550px;
  }

  .share-image {
    margin: 4.25rem auto 3rem;
    position: relative;
    left: -22px;
    width: calc(100vh * 0.7);
    max-width: 740px;
  }

  h1, h2 {
    width: 100%;
  }

  h1 {
    font-size: 44px;
  }

  h2 {
    font-size: 21px;
  }

  .share-btn {
    font-size: 22px;
  }

  footer {
    flex-direction: row;
    text-align: left;
    padding-left: 2%;
    padding-right: 2%;
  }

  footer .left {
    font-size: 18px;
    margin-bottom: 0;
  }
}

@media (min-width: 992px) {
  .fixed-photos.left  {
    left: -400px;
  }

  .fixed-photos.right  {
    right: -400px;
  }
}

@media (min-width: 1200px) {}

@media (min-width: 1644px) {
  h1 { font-size: 56px; }
  h2 { font-size: 24px; }
}

@media (min-width: 1920px) {
  .fixed-photos.left  {
    left: -150px;
  }

  .fixed-photos.right  {
    right: -150px;
  }

  .share-image {
    margin-top: 9.5rem;
    margin-bottom: 4rem;
  }
}
`;
