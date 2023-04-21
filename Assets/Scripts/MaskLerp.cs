using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MaskLerp : MonoBehaviour
{
    public float startScale = 1.5f;
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        transform.localScale = Vector3.Lerp(transform.localScale*startScale, transform.localScale, Time.deltaTime * 10);
    }
}
