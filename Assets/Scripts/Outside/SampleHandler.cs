using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SampleHandler : MonoBehaviour
{
    public GameObject[] sample;
    public GameObject[] sampleInScanMode;

    void Start()
    {
        sample = GameObject.FindGameObjectsWithTag("sample");
        sampleInScanMode = GameObject.FindGameObjectsWithTag("sampleInScanMode");
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public void SampleCollected(bool isInScanMode, GameObject collectedSample)
    {
        if (!isInScanMode)
        {
            int i = System.Array.IndexOf(sample, collectedSample);
            collectedSample.SetActive(false);
            sampleInScanMode[i].gameObject.SetActive(false);
        }
        else
        {
            int i = System.Array.IndexOf(sampleInScanMode, collectedSample);
            sampleInScanMode[i].SetActive(false);
            collectedSample.gameObject.SetActive(false);
        }   
    }
}
