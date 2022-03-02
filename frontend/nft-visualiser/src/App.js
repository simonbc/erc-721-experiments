import { useState, useEffect } from "react";
import styled from "styled-components";
import { ethers } from "ethers";
import axios from "axios";

import { connect } from "./helpers";
import Contract from "./SuperMarioWorldCollection.json";
import { contractAddress } from "./config";

import { NFTCard } from "./components/NFTCard";
import { NFTModal } from "./components/NFTModal";

function App() {
  const [showModal, setShowModal] = useState(false);
  const [selectedNft, setSelectedNft] = useState();
  const [nfts, setNfts] = useState([]);

  const init = async () => {
    const address = await connect();
    if (address) {
      getNfts(address);
    }
  };

  useEffect(() => {
    init();
  }, []);

  async function getMetadataFromIpfs(tokenURI) {
    console.log("Fetching", tokenURI);
    const metadata = await axios.get(tokenURI);
    return metadata.data;
  }

  async function getNfts(address) {
    const rpc = "https://rpc-mumbai.maticvigil.com/";
    const ethersProvider = new ethers.providers.JsonRpcProvider(rpc);

    let nftCollection = new ethers.Contract(
      contractAddress,
      Contract.abi,
      ethersProvider
    );

    const numberOfNfts = (await nftCollection.tokenCount()).toNumber();

    const collectionSymbol = await nftCollection.symbol();
    const accounts = Array(numberOfNfts).fill(address);
    const ids = Array.from({ length: numberOfNfts }, (_, i) => i + 1);

    const copies = await nftCollection.balanceOfBatch(accounts, ids);

    const nfts = [];
    let baseUrl = "";

    for (let i of ids) {
      let tokenURI;
      if (i === 1) {
        tokenURI = await nftCollection.uri(i);
        baseUrl = tokenURI.replace(/\d+.json/, "");
      } else {
        tokenURI = baseUrl + `${i}.json`;
      }

      const metadata = await getMetadataFromIpfs(tokenURI);
      metadata.symbol = collectionSymbol;
      metadata.copies = copies[i - 1];

      nfts.push(metadata);
    }

    setNfts(nfts);
  }

  function toggleModal(i) {
    if (i >= 0) {
      setSelectedNft(nfts[i]);
    }
    setShowModal(!showModal);
  }

  return (
    <div className="App">
      <Container>
        <Title> Super Mario World Collection </Title>
        <Subtitle> The rarest and best of Super Mario World </Subtitle>
        <Grid>
          {nfts.map((nft, i) => (
            <NFTCard nft={nft} key={i} toggleModal={() => toggleModal(i)} />
          ))}
        </Grid>
      </Container>
      {showModal && (
        <NFTModal nft={selectedNft} toggleModal={() => toggleModal()} />
      )}
    </div>
  );
}

const Title = styled.h1`
  margin: 0;
  text-align: center;
`;
const Subtitle = styled.h4`
  color: gray;
  margin-top: 0;
  text-align: center;
`;
const Container = styled.div`
  width: 70%;
  max-width: 1200px;
  margin: auto;
  margin-top: 100px;
`;
const Grid = styled.div`
  display: grid;
  grid-template-columns: 1fr 1fr 1fr 1fr;
  row-gap: 40px;
`;

export default App;
