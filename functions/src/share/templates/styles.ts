export default `
html, body {
  margin: 0;
  padding: 0;
  height: 100%;
}

body {
  font-family: "Google Sans", sans-serif;
  font-size: 12px;
  background-image: url("{{{assetUrls.bgMobile}}}");
  background-repeat: no-repeat;
  background-position: center;
  background-size: cover;
  display: flex;
  flex-direction: column;
}

*, ::before, ::after {
  box-sizing: border-box;
}

.fixed-photos {
  display: none;
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
  box-shadow: -3px 9px 7px 1px rgba(0, 0, 0, 0.4);
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
  font-weight: 700;
  width: 67%;
  margin: 0 auto 25px;
}

h2 {
  line-height: 1.3;
  font-size: 18px;
  font-weight: 100;
  width: 75%;
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

@media (min-width:768px) {
  body {
    background-image: url("{{{assetUrls.bg}}}");
  }

  .fixed-photos {
    position: fixed;
    top: 0;
    background-repeat: no-repeat;
    background-size: contain;
    z-index: -1;
    display: block;
    width: 780px;
  }

  .fixed-photos.left  {
    left: -22%;
  }

  .fixed-photos.right  {
    right: -22%;
  }

  .share-image {
    margin: 4.25rem auto 3rem;
    width: 710px;
    position: relative;
    left: -22px;
  }

  h1, h2 {
    width: 100%;
  }

  h1 {
    font-size: 56px;
  }

  h2 {
    font-size: 24px;
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
`;
