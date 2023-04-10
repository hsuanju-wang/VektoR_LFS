using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ScannerAlpha : MonoBehaviour
{
    public Material scanMaterial;
    // Start is called before the first frame update
    void Start()
    {
        StartCoroutine(spawnAlpha());           
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    private IEnumerator spawnAlpha()
    {
        scanMaterial.SetFloat("Alpha", 1);
        yield return new WaitForSeconds(1f);
        scanMaterial.SetFloat("Alpha", 0);
    }
}
