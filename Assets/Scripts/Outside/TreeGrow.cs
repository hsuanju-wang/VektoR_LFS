using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TreeGrow : MonoBehaviour
{
    public Material treeMaterial;
    public float duration = 4f;
    float startTime = 0f;
    Renderer rend;
    // Start is called before the first frame update
    void Awake()
    {
        treeMaterial.SetFloat("_Grow", 0);
    }

    // Update is called once per frame
    void Update()
    {
        treeMaterial.SetFloat("_Grow", Mathf.Lerp(0, 1, startTime / duration));
        startTime += Time.deltaTime;
    }
}
